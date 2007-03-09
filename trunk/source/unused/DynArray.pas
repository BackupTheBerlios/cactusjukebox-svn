(* Jean.F.Soucaille May 2002 V0.1 *)

UNIT DynArray;

Interface
uses SysUtils;
Type D_Array=OBJECT
Procedure Allocate(Data_Size, Nb_Dims: Integer;DimTab:ARRAY Of Integer);
Procedure Put(Var Data;DimTab:ARRAY Of Integer);
Procedure Get(Var Data;DimTab:ARRAY Of Integer);
Procedure PutNext(Var Data);
Procedure GetNext(Var Data);
Procedure SetPos(DimTab:Array of Integer);
Procedure SetInc(Dim:Integer);
Procedure Free;
Procedure SaveAsFile(FileName:String);
Procedure LoadFromFile(FileName:String);
Function  GetNbDims:Integer;
Function  GetDim(Dim:Integer):Integer;

private
    Base,Source,Destination:Pointer;
    Offset_Data,SizeInt,FileHandle,Increment:LongInt;
    NbBytes,NbElmnts,DataSize,FileReadStatus,BufferL,BufferL_2:LongInt;
    NbDims:Integer;
Function Offset(Coordinates:Array Of Integer):LongInt;

End;

Implementation


Function D_Array.Offset(Coordinates:Array Of Integer):LongInt;
var
  Index:LongInt;
Begin
  Offset:=Coordinates[0]*DataSize;
  Source:=Base;
  For index:=1 to NbDims-1 do
   Begin
     Source:=Source+SizeInt;
     Move(Source^,BufferL,SizeInt);
     Offset:=Offset+Coordinates[Index]*BufferL;
   end;
   Offset:=Offset+Offset_Data;
End;

Procedure D_Array.Allocate(Data_Size, Nb_Dims: Integer;DimTab:ARRAY Of Integer);
Var
  Index:LongInt;

Begin
  If Base<>nil then FreeMem(Base,NbBytes);

  NbDims:=Nb_Dims;
  NbElmnts:=1;
  DataSize:=Data_Size;
  SizeInt:=SizeOf(LongInt(0));
  For Index:=0 to NbDims-1 do NbElmnts:=NbElmnts*DimTab[index];
  Offset_data:=(NbDims+2)*SizeInt;
  NbBytes:=NbElmnts*DataSize+Offset_Data;
  Base:=GetMem(NbBytes);
  Destination:=Base;
  BufferL:=Offset_data;
  Move(BufferL,Destination^,SizeInt);
  BufferL:=1;
  For index:=1 to NbDims do
      begin
      bufferL:=bufferL*DimTab[index-1];
      Destination:=Base+Index*SizeInt;
      BufferL_2:=BufferL*DataSize;
      Move(bufferL_2,Destination^,SizeInt);
      end;
  bufferL:=DataSize;
  Destination:=Destination+SizeInt;
  Move(bufferL,Destination^,SizeInt);
End;

Procedure D_Array.Free;
Begin
  If Base <> nil then FreeMem(Base,NbBytes);
End;

Function  D_Array.GetNbDims:Integer;
Begin
  GetNbDims:=(Offset_Data Div SizeOf(LongInt(0)))-2 ;
End;

Function  D_Array.GetDim(Dim:Integer):Integer;

Begin
 Source:=Base+Dim*SizeInt;
 Move(Source^,bufferL_2,SizeInt);
 Source:=Base+(Dim-1)*SizeInt;
 Move(Source^,BufferL,SizeInt);
 If Dim=1 then BufferL:=DataSize;
 GetDim:=bufferL_2 Div bufferL;
End;



Procedure D_Array.Put(Var Data;DimTab:ARRAY Of Integer);
Begin
  Destination:=Base+Offset(DimTab);
  Move(Data,Destination^,DataSize);
End;

Procedure D_Array.Get(Var Data;DimTab:ARRAY Of Integer);
Begin
  Source:=Base+Offset(DimTab);
  Move(Source^,Data,DataSize);
End;

Procedure D_Array.SetPos(DimTab:Array of Integer);
Begin
  Destination:=Base+Offset(DimTab);
  Source:=Base+Offset(DimTab);
End;

Procedure D_Array.SetInc(Dim:Integer);
Begin
  Move((Base+(Dim-1)*SizeInt)^,Increment,SizeInt);
   If Dim=1 then Increment:=DataSize;
End;

Procedure D_Array.PutNext(Var Data);
Begin
   Destination:=Destination+Increment;
   Move(Data,Destination^,DataSize);
End;

Procedure D_Array.GetNext(Var Data);
Begin
   Source:=Source+Increment;
   Move(Source^,Data,DataSize);
End;

Procedure D_Array.SaveAsFile(FileName:String);
Begin
  FileHandle:=FileCreate(FileName);
  FileWrite(FileHandle,Base^,NbBytes);
  FileClose(FileHandle);
End;

Procedure D_Array.LoadFromFile(FileName:String);
Begin
  SizeInt:=SizeOf(LongInt(0));
  FileHandle:=FileOpen(FileName,fmOpenRead);
  if FileHandle=-1 then writeln('File not found');
  FileSeek(FileHandle,0,fsFromBeginning);
  FileReadStatus:=FileRead(FileHandle,Offset_Data,SizeInt);
  FileSeek(FileHandle,(Offset_Data-SizeInt),fsFromBeginning);
  FileReadStatus:=FileRead(FileHandle,DataSize,SizeInt);
  FileSeek(FileHandle,(Offset_Data-2*SizeInt),fsFromBeginning);
  FileReadStatus:=FileRead(FileHandle,NbElmnts,SizeInt);
  NbBytes:=Offset_Data+NbElmnts;
  Base:=GetMem(NbBytes);
  FileSeek(FileHandle,0,fsFromBeginning);
  FileRead(FileHandle,Base^,NbBytes);
  NbDims:=GetNbDims;
  FileClose(FileHandle);
End;


End.
