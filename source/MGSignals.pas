//******************************************************************************
//***                     COMMON DELPHI FUNCTIONS                            ***
//***                                                                        ***
//***        (c) Massimo Magnano 11-11-2004.                                 ***
//***                                                                        ***
//***                                                                        ***
//******************************************************************************
//
//  File        : MGSignals.pas   REV. 1.1   (22-06-2005)
//
//  Description : Implementazione di un dispatcher di messaggi (svincolato dalla VCL)
//                verso delle classi registrate.
//                Implements a message dispatcher (disengaged from VCL)
//                to registered classes.
//
//******************************************************************************
//   WARNING -TO TEST IN ExtFind  (compare of method is different under Lazarus?)


/////////////////////////////////////////////////////////////
//SK: I commented out reference to missing ObjectInstance unit 
//TODO: Check reference to unit ObjectInstances
//
///////////////////////////////////////////////////////////


unit MGSignals;
{$mode delphi}{$H+}

interface
uses MGTree16, MGList,
     {$ifdef WINDOWS}
      Windows, {ObjectInstance,}
     {$endif}
     Messages, Forms;

Type
    TSignalMethod = function (var Message: TMessage):Boolean of object;
    //necessario xchè TSignalMethod è una coppia di puntatori...
    //necessary because TSignalMethod is a pair of pointers
    PSignalMethod =^TSignalMethod;

    TSignalMethodsList = class (TMGList)
    protected
        function allocData :Pointer; override;
        procedure deallocData(pData :Pointer); override;
        function CompBySignalMethod(xTag :Pointer; ptData1, ptData2 :Pointer) :Boolean;
    public
        function Add(AMethod :TSignalMethod) :PSignalMethod; overload;
        function Find(AMethod :TSignalMethod) : Integer; overload;
        function ExtFind(AMethod :TSignalMethod) : Pointer; overload;
        function Delete(AMethod :TSignalMethod) :Boolean; overload;
        function DeleteByClassMethod(AMethod :TSignalMethod) :Boolean;
        procedure DeleteByClass(ClassPointer :TObject);
        function CallAllMethods(var Message: TMessage) :Boolean;
    end;

    TMGSignals = class
    protected
     {$ifdef WINDOWS}
       rHandle  : HWND;
     {$endif}
       rClients : TMGTree16;

       procedure FreeClassOnList(Tag :Integer; wMessageID :Integer; wMessageList :TObject);
       procedure FreeLists(Tag :Integer; wMessageID :Integer; wMessageList :TObject);

       procedure MainWndProc(var Message: TMessage);
       procedure WndProc(var Message: TMessage); virtual;
    public
       constructor Create; reintroduce;
       {$ifdef WINDOWS} overload;
       constructor Create(HandleClassName, HandleWindowName :String); overload;
       {$endif}
       destructor Destroy; override;
       procedure Connect(ClassMethod :TSignalMethod; MessageID :Integer);
       procedure Disconnect(ClassMethod :TSignalMethod; MessageID :Integer); overload;
       procedure Disconnect(ClassPointer :TObject); overload;
       function Signal(MessageID :Cardinal; WParam, LParam :Integer; var Handled :Boolean) :Integer; overload;
       function Signal(var Message: TMessage) :Boolean; overload;

       {$ifdef WINDOWS}
       property Handle: HWND read rHandle;
       {$endif}
    end;

implementation

// =============================================================================

function TSignalMethodsList.allocData :Pointer;
begin
     GetMem(Result, sizeOf(TSignalMethod));
end;

procedure TSignalMethodsList.deallocData(pData :Pointer);
begin
     FreeMem(pData, sizeOf(TSignalMethod));
end;

function TSignalMethodsList.CompBySignalMethod(xTag :Pointer; ptData1, ptData2 :Pointer) :Boolean;
Var
   m1,
   m2 :TSignalMethod;
   Message1: TMessage;

begin
     m1 :=PSignalMethod(ptData1)^;
     m2 :=PSignalMethod(ptData2)^;

     Result := (TMethod(m1).Data = TMethod(m2).Data) and //Stessa Classe (Instanza) Same Instance
               (TMethod(m1).Code = TMethod(m2).Code);     //Stesso Metodo           Same Method


               //(@m1 = @m2); dovrebbe essere così, ma un metodo di due classi
               //dello stesso tipo viene sempre considerato uguale...
               //EN
               //(@m1 = @m2); should be so, but a method of the same class type
               //is always considered the same...
               //esempio (example):
               //     Classe1, Classe2 :TForm;
               //  Classe1.func = Classe2.func  because
               //    TForm.func = TForm.func    but Classe1 is not the same of Class2
end;

function TSignalMethodsList.Add(AMethod :TSignalMethod) :PSignalMethod;
begin
     Result :=ExtFind(AMethod);
     if (Result=Nil)
     then begin
               Result :=Add;
               Result^ :=AMethod;
          end;
end;

function TSignalMethodsList.Find(AMethod :TSignalMethod) : Integer;
Var
   auxPointer :PSignalMethod;

begin
     GetMem(auxPointer, sizeOf(TSignalMethod));
     auxPointer^ :=AMethod;
     Result :=Find(auxPointer, 0, CompBySignalMethod);
     FreeMem(auxPointer);
end;

function TSignalMethodsList.ExtFind(AMethod :TSignalMethod) : Pointer;
Var
   auxPointer :PSignalMethod;

begin
     GetMem(auxPointer, sizeOf(TSignalMethod));
     auxPointer^ :=AMethod;
     Result :=ExtFind(auxPointer, 0, CompBySignalMethod);
     FreeMem(auxPointer);
end;


function TSignalMethodsList.Delete(AMethod :TSignalMethod) :Boolean;
begin
     Result :=DeleteByClassMethod(AMethod);
end;

function TSignalMethodsList.DeleteByClassMethod(AMethod :TSignalMethod) :Boolean;
Var
   auxPointer :PSignalMethod;

begin
     GetMem(auxPointer, sizeOf(TSignalMethod));
     auxPointer^ :=AMethod;
     Result :=Delete(auxPointer, 0, CompBySignalMethod);
     FreeMem(auxPointer);
end;

procedure TSignalMethodsList.DeleteByClass(ClassPointer :TObject);
Var
   Pt :PSignalMethod;

begin
     Pt :=FindFirst;
     while (Pt<>Nil) do
     begin
          if (TMethod(Pt^).Data = ClassPointer)
          then DeleteCurrent;

          Pt :=FindNext;
     end;
     FindClose;
end;

function TSignalMethodsList.CallAllMethods(var Message: TMessage) :Boolean;
Var
   Pt  :PSignalMethod;

begin
     Result :=False;

     Pt :=FindFirst;
     while (Pt<>Nil) do
     begin
          if Assigned(Pt^)
          then Result :=Pt^(Message)
          else Result :=False;

          if Result
          then Pt :=FindNext
          else Pt :=Nil;
     end;
     FindClose;
end;


// =============================================================================

constructor TMGSignals.Create;
begin
     inherited Create;
     rClients :=TMGTree16.Create;
     {$ifdef WINDOWS}
       rHandle :=0;
     {$endif}
end;

{$ifdef WINDOWS}
constructor TMGSignals.Create(HandleClassName, HandleWindowName :String);
begin
     Create;
 //    rHandle := ObjectInstance.AllocateHWnd(MainWndProc, HandleClassName, HandleWindowName);
end;
{$endif}

procedure TMGSignals.FreeLists(Tag :Integer; wMessageID :Integer; wMessageList :TObject);
begin
     if (wMessageList<>Nil)
     then TSignalMethodsList(wMessageList).Free;
end;

destructor TMGSignals.Destroy;
begin
{$ifdef WINDOWS}
//     if (rHandle<>0)
//     then ObjectInstance.DeallocateHWnd(rHandle);
{$endif}

     rClients.Clear(0, FreeLists);
     rClients.Free;
     inherited Destroy;
end;

procedure TMGSignals.MainWndProc(var Message: TMessage);
begin
  try
    WndProc(Message);
  except
    Application.HandleException(Self);
  end;
end;

procedure TMGSignals.WndProc(var Message: TMessage);
Var
   Handled :Boolean;

begin
     with Message do
     begin
          Result := Signal(Msg, wParam, lParam, Handled);
          {$ifdef WINDOWS}
          if not(Handled)
          then Result := DefWindowProc(rHandle, Msg, wParam, lParam);
          {$endif}
     end;
end;

procedure TMGSignals.Connect(ClassMethod :TSignalMethod; MessageID :Integer);
Var
   TreeData :PMGTree16Data;
   theList  :TSignalMethodsList;

begin
     TreeData :=rClients.Add(MessageID);
     if (TreeData<>Nil) then
     begin
          theList :=TSignalMethodsList(TreeData^.UData);
          if (theList=nil) //La Lista non esiste...
          then begin
                    theList :=TSignalMethodsList.Create;
                    TreeData^.UData :=theList;
               end;
          theList.Add(ClassMethod);
     end;
end;

procedure TMGSignals.Disconnect(ClassMethod :TSignalMethod; MessageID :Integer);
Var
   uMessageID   :Integer;
   uMessageList :TObject;

begin
     if Assigned(ClassMethod) then
     begin
          if rClients.Find(MessageID, uMessageID, uMessageList)
          then if (uMessageList<>Nil)
               then begin
                         TSignalMethodsList(uMessageList).DeleteByClassMethod(ClassMethod);
                         if (TSignalMethodsList(uMessageList).Count=0)
                         then rClients.Del(MessageID);
                    end;
      end;
end;

procedure TMGSignals.FreeClassOnList(Tag :Integer; wMessageID :Integer; wMessageList :TObject);
Var
   ClassPointer :TObject;

begin
     ClassPointer :=TObject(Tag);
     if (ClassPointer<>Nil) and (wMessageList<>Nil) then
     begin
          TSignalMethodsList(wMessageList).DeleteByClass(ClassPointer);
     end;
end;

procedure TMGSignals.Disconnect(ClassPointer :TObject);
begin
     rClients.WalkOnTree(Integer(ClassPointer), FreeClassOnList);
end;

function TMGSignals.Signal(MessageID :Cardinal; WParam, LParam :Integer; var Handled :Boolean) :Integer;
Var
   Message :TMessage;

begin
     Message.Msg :=MessageID;
     Message.WParam :=WParam;
     Message.LParam :=LParam;
     Handled :=Signal(Message);
     Result :=Message.Result;
end;

function TMGSignals.Signal(var Message: TMessage):Boolean;
Var
   uMessageID :Integer;
   uMessageList :TObject;

begin
     Result :=False;

     if rClients.Find(Message.Msg, uMessageID, uMessageList)
     then if (uMessageList<>Nil)
          then Result :=TSignalMethodsList(uMessageList).CallAllMethods(Message);
end;

end.
