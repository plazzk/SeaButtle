unit MainUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids, Vcl.Menus,
  Vcl.ExtDlgs;

type
  TMatrix = Array Of Array Of Integer;
  TCoordinates = Array[0..1] Of 0..9;
  TMainForm = class(TForm)
    MainMenu: TMainMenu;
    StringGridUser1: TStringGrid;
    StringGridUser2: TStringGrid;
    WhoPlayLabel: TLabel;
    CoordEdit: TEdit;
    FileButtons: TMenuItem;
    OpenFile1Button: TMenuItem;
    OpenTextFileDialog: TOpenTextFileDialog;
    OpenFile2Button: TMenuItem;
    ShootButton: TButton;

    Procedure PrintCoordinatesLine();
    Procedure ReadBattleFieldFormFile(Const PathToFile: String; Var StateOfBattleFieldUser: TMatrix; Var StateShipsUser: TMatrix);
    Procedure SwitchPlayers();
    procedure StringGridUser2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure OpenFile1ButtonClick(Sender: TObject);
    procedure OpenFile2ButtonClick(Sender: TObject);
    procedure StringGridUser1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CoordEditKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure ShootButtonClick(Sender: TObject);
    procedure CoordEditChange(Sender: TObject);
    Procedure HurtShip(Const Coord: TCoordinates; Var StateOfBattleFieldUser, StateShipsUser: TMatrix);
    Procedure Shoot(Const Coords: TCoordinates; Var StateOfBattleFieldUser, StateShipsUser: TMatrix);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

Var
    MainForm: TMainForm;
    IsFirstPlayer, IsWin, IsFirstPlayerFull, IsSecondPlayerFull, IsHit : Boolean;
    StateShipsUser1, StateShipsUser2, StateOfBattleFieldUser1, StateOfBattleFieldUser2 : TMatrix;
    k: Integer;
    Const Letters = [192, 193, 194, 195, 196, 197, 199, 200, 201, 203];



Implementation

{$R *.dfm}


Procedure TMainForm.PrintCoordinatesLine();
Var
    Alphabet: String;
Begin
    Alphabet := 'АБВГДЕЖЗИК';
    For Var I := 1 to StringGridUser1.ColCount - 1 Do
    Begin
        StringGridUser1.Cells[I,0] := Alphabet[I];
        StringGridUser2.Cells[I,0] := Alphabet[I];
        StringGridUser1.Cells[0,I] := IntToStr(I);
        StringGridUser2.Cells[0,I] := IntToStr(I);
    End;
End;

procedure TMainForm.CoordEditChange(Sender: TObject);
begin
    If (Length(CoordEdit.Text) = 3) Then
        ShootButton.Visible := true;
end;

procedure TMainForm.CoordEditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    If Not (Key in Letters) Then
        beep;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
    k := 0;
    PrintCoordinatesLine();
    IsFirstPlayer := True;
end;

Procedure TMainForm.OpenFile1ButtonClick(Sender: TObject);
Var
    PathToFile : String;
Begin
    If OpenTextFileDialog.execute() Then
            PathToFile := OpenTextFileDialog.FileName;
    ReadBattleFieldFormFile(PathToFile, StateOfBattleFieldUser1, StateShipsUser1);
    IsFirstPlayerFull := True;
    If IsSecondPlayerFull Then
        CoordEdit.Visible := True;
End;

Procedure TMainForm.OpenFile2ButtonClick(Sender: TObject);
Var
    PathToFile : String;
Begin
    If OpenTextFileDialog.execute() Then
            PathToFile := OpenTextFileDialog.FileName;
    ReadBattleFieldFormFile(PathToFile, StateOfBattleFieldUser2, StateShipsUser2);
    IsSecondPlayerFull := True;
    If IsFirstPlayerFull Then
        CoordEdit.Visible := True;
End;



procedure TMainForm.StringGridUser1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
    If(Key <> null) Then
end;

Procedure TMainForm.StringGridUser2KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
Begin
    If(Key <> null) Then
End;

Procedure TMainForm.ReadBattleFieldFormFile(Const PathToFile: String; Var StateOfBattleFieldUser: TMatrix; Var StateShipsUser: TMatrix);
Var
    UserFile: TextFile;
    I, J, CurrentSize: Integer;
    Symbol: Char;
    ShipSizes: Array Of Integer;
    ShipIndex: Integer;

    Procedure InitializeMatrices;
    Begin
        SetLength(StateOfBattleFieldUser, 10, 10);
        SetLength(StateShipsUser, 9, 10);
        SetLength(ShipSizes, 10);
        For Var I := 0 To 8 Do
            For Var J := 0 To 9 Do
                StateShipsUser[I, J] := -6;
    End;

    Procedure SortShipsBySize;
    Var
        I, J, Temp: Integer;
        TempColumn: Array [0 .. 8] Of Integer;
    Begin
        For I := 0 To ShipIndex - 2 Do
        Begin
            For J := 0 To ShipIndex - 2 - I Do
            Begin
                If ShipSizes[J] < ShipSizes[J + 1] Then
                Begin
                    Temp := ShipSizes[J];
                    ShipSizes[J] := ShipSizes[J + 1];
                    ShipSizes[J + 1] := Temp;
                    For Var K := 0 To 8 Do
                    Begin
                        TempColumn[K] := StateShipsUser[K, J];
                        StateShipsUser[K, J] := StateShipsUser[K, J + 1];
                        StateShipsUser[K, J + 1] := TempColumn[K];
                    End;
                End;
            End;
        End;
    End;
    Procedure MarkShip(X, Y: Integer; Var Size: Integer; ShipCol: Integer);
    Begin
        If ((X >= 0) And (X < 10) And (Y >= 0) And (Y < 10)) And (StateOfBattleFieldUser[X, Y] = 1) Then
        Begin
            StateShipsUser[Size * 2 , ShipCol] := Y;
            StateShipsUser[Size * 2+1, ShipCol] := X;
            StateOfBattleFieldUser[X, Y] := -1;
            Size := Size + 1;
            MarkShip(X + 1, Y, Size, ShipCol);
            MarkShip(X - 1, Y, Size, ShipCol);
            MarkShip(X, Y + 1, Size, ShipCol);
            MarkShip(X, Y - 1, Size, ShipCol);
        End;
    End;
    Procedure CountAliveCells;
    Var
        I, X, Y: Integer;
    Begin
        For Var J := 0 To ShipIndex - 1 Do
        Begin
            I := 0;
            StateShipsUser[8, J] := 0;
            While I < 7 Do
            Begin
                X := StateShipsUser[I, J];
                Y := StateShipsUser[I + 1, J];
                If (X <> -6) And (Y <> -6) And (StateOfBattleFieldUser[Y, X] > 0) Then
                    StateShipsUser[8, J] := StateShipsUser[8, J] + 1;
                I := I + 2;
            End;
        End;
    End;
    Procedure SetLastRowValues;
Begin
    StateShipsUser[8, 0] := 4;
    StateShipsUser[8, 1] := 3;
    StateShipsUser[8, 2] := 3;
    StateShipsUser[8, 3] := 2;
    StateShipsUser[8, 4] := 2;
    StateShipsUser[8, 5] := 2;
    StateShipsUser[8, 6] := 1;
    StateShipsUser[8, 7] := 1;
    StateShipsUser[8, 8] := 1;
    StateShipsUser[8, 9] := 1;
End;

Begin
    InitializeMatrices;
    AssignFile(UserFile, PathToFile);
    Reset(UserFile);
    Try
        For I := 0 To High(StateOfBattleFieldUser) Do
        Begin
            For J := 0 To High(StateOfBattleFieldUser[I]) Do
            Begin
                Repeat
                    Read(UserFile, Symbol);
                Until Not(Symbol = ' ');

                If (Symbol = 'M') Then
                    StateOfBattleFieldUser[I, J] := 0
                Else
                    If (Symbol = 'K') Then
                        StateOfBattleFieldUser[I, J] := 1;
            End;
            ReadLn(UserFile);
        End;

        ShipIndex := 0;
        For I := 0 To High(StateOfBattleFieldUser) Do
        Begin
            For J := 0 To High(StateOfBattleFieldUser[I]) Do
            Begin
                If StateOfBattleFieldUser[I, J] = 1 Then
                Begin
                    CurrentSize := 0;
                    MarkShip(I, J, CurrentSize, ShipIndex);
                    For Var XPos := 0 To High(StateOfBattleFieldUser) Do
                    Begin
                        For Var YPos := 0 To High(StateOfBattleFieldUser[I]) Do
                        Begin
                            If StateOfBattleFieldUser[XPos, YPos] = -1 Then
                                StateOfBattleFieldUser[XPos, YPos] := CurrentSize;
                        End;
                    End;
                    ShipSizes[ShipIndex] := CurrentSize;
                    ShipIndex := ShipIndex + 1;
                End;
            End;
        End;
        SortShipsBySize;
        CountAliveCells;
        SetLastRowValues;
    Finally
        CloseFile(UserFile);
    End;
End;

Function NotShooted(Const Coords : TCoordinates; Const StateOfBattleFieldUser : TMatrix) : Boolean;
Var
    IsNotShooted : Boolean;
Begin
    If (StateOfBattleFieldUser[Coords[0], Coords[1]] <> -6) And (StateOfBattleFieldUser[Coords[0], Coords[1]] <> -5)  Then
        IsNotShooted := True
    Else
        IsNotShooted := False;
    NotShooted := IsNotShooted;
End;
Function IsThereAnyShips(Const StateShipsUser: TMatrix): Boolean;
Var
    I: Integer;
Begin
    IsThereAnyShips := False;
    For I := 0 To High(StateShipsUser[8]) Do
    Begin
        If StateShipsUser[8, I] > 0 Then
            IsThereAnyShips := True;
    End;
End;
Function IsShipInCell(Const Coords : TCoordinates; Const StateOfBattleFieldUser, StateShipsUser : TMatrix) : Boolean;
Begin
    IsShipInCell := StateOfBattleFieldUser[Coords[0]][Coords[1]] > 0;
End;
Function IsShipAlive(Const Coords : TCoordinates; Const StateShipsUser : TMatrix): Boolean;
Var
  J: Integer;
Begin
    IsShipAlive := False;
    For J := 0 To High(StateShipsUser[High(StateShipsUser)]) Do
        If StateShipsUser[High(StateShipsUser)][J] <> -6 Then
            IsShipAlive := True;
End;

Procedure DestroyShip(Const Coord: TCoordinates; Var StateOfBattleFieldUser, StateShipsUser: TMatrix);
Var
    NumOfShip, LengthOfShip: Integer;
    CurrentCoord: TCoordinates;
Begin
    For Var I := 0 To 7 Do
        For Var J := 0 To 9 Do
            If I Mod 2 = 1 Then
                Break
            Else
                If (Coord[0] = StateShipsUser[I, J]) And (Coord[1] = StateShipsUser[I + 1, J]) Then
                Begin
                    NumOfShip := J;
                    LengthOfShip := StateShipsUser[0, J];
                    Break
                End;
    For Var J := LengthOfShip - 1 Downto 0 Do
    Begin
        CurrentCoord[0] := StateShipsUser[J * 2, NumOfShip];
        CurrentCoord[1] := StateShipsUser[J * 2 + 1, NumOfShip];
        StateOfBattleFieldUser[CurrentCoord[0], CurrentCoord[1]] := -6;
        StateOfBattleFieldUser[CurrentCoord[0] - 1, CurrentCoord[1] - 1] := -5;
        StateOfBattleFieldUser[CurrentCoord[0] - 1, CurrentCoord[1] + 1] := -5;
        StateOfBattleFieldUser[CurrentCoord[0] + 1, CurrentCoord[1] + 1] := -5;
        StateOfBattleFieldUser[CurrentCoord[0] + 1, CurrentCoord[1] - 1] := -5;
        If StateOfBattleFieldUser[CurrentCoord[0], CurrentCoord[1] - 1] <> -6 Then
            StateOfBattleFieldUser[CurrentCoord[0], CurrentCoord[1] - 1] := -5;
        If StateOfBattleFieldUser[CurrentCoord[0] - 1, CurrentCoord[1]] <> -6 Then
            StateOfBattleFieldUser[CurrentCoord[0] - 1, CurrentCoord[1]] := -5;
        If StateOfBattleFieldUser[CurrentCoord[0], CurrentCoord[1] + 1] <> -6 Then
            StateOfBattleFieldUser[CurrentCoord[0], CurrentCoord[1] + 1] := -5;
        If StateOfBattleFieldUser[CurrentCoord[0] + 1, CurrentCoord[1]] <> -6 Then
            StateOfBattleFieldUser[CurrentCoord[0] + 1, CurrentCoord[1]] := -5
    End;
End;

Procedure TMainForm.HurtShip(Const Coord: TCoordinates; Var StateOfBattleFieldUser, StateShipsUser: TMatrix);
Var
    I, J, temp1, temp2: Integer;
Begin
    I := 0;
    While I < 8 Do
    Begin
        For J := 0 To 9 Do
        Begin
            If (StateShipsUser[I, J] = Coord[0]) And (StateShipsUser[I + 1, J] = Coord[1]) Then
            Begin
                Dec(StateShipsUser[8, J]);
                If (StateShipsUser[8, J] = 0) Then
                Begin
                    DestroyShip(Coord, StateOfBattleFieldUser, StateShipsUser);
                    //временная хути
                    If (IsFirstPlayer) Then
                        StringGridUser1.Cells[Coord[0] + 1, Coord[1] + 1] := 'У'
                    Else
                        StringGridUser2.Cells[Coord[0] + 1, Coord[1] + 1] := 'У'
                End
                Else
                    If(IsFirstPlayer) Then
                        StringGridUser1.Cells[Coord[0] + 1, Coord[1] + 1] := 'Р'
                    Else
                        StringGridUser2.Cells[Coord[0] + 1, Coord[1] + 1] := 'Р'
            End;
        End;
        I := I + 2;
    End;
    StateOfBattleFieldUser[Coord[0], Coord[1]] := -6;
End;

Function InputCoordinates(UserInput: String): TCoordinates;
Var
    Column: Char;
    Row: Integer;
    X, Y: Integer;
    IsCorrect: Boolean;
    Answer: TCoordinates;
Begin

    Column := UserInput[1];

    If Ord(Column) = Ord('К') Then
        X := Ord(Column) - Ord('А') - 1
    Else
        X := Ord(Column) - Ord('А');
    If Length(UserInput) = 3 Then
        Row := StrToInt(Copy(UserInput, 3, 1))
    Else
        If Length(UserInput) = 4 Then
            Row := StrToInt(Copy(UserInput, 3, 2));

    Y := Row - 1;

    Answer[0] := X;
    Answer[1] := Y;
    InputCoordinates := Answer;
End;



Procedure TMainForm.Shoot(Const Coords: TCoordinates; Var StateOfBattleFieldUser, StateShipsUser: TMatrix);

Begin
    If (k = 20) Then
      Var popa := 2+2;
    Inc(k);
    If NotShooted(Coords, StateOfBattleFieldUser) Then
        If IsShipInCell(Coords, StateOfBattleFieldUser, StateShipsUser) Then
            HurtShip(Coords, StateOfBattleFieldUser, StateShipsUser)
        Else
        Begin
             StateOfBattleFieldUser[Coords[0], Coords[1]] := -5;
             If(IsFirstPlayer) Then
                StringGridUser1.Cells[Coords[0] + 1, Coords[1] + 1] := '.'
             Else
                StringGridUser2.Cells[Coords[0] + 1, Coords[1] + 1] := '.';
            IsHit := False;
        End
    Else
            WhoPlayLabel.Caption := WhoPlayLabel.Caption + #13#10 +'Введена координата уже задействованная';


End;

procedure TMainForm.ShootButtonClick(Sender: TObject);
begin
      If(Length(CoordEdit.Text) = 3) Then
          If(IsFirstPlayer) Then
              Shoot(InputCoordinates(CoordEdit.Text), StateOfBattleFieldUser1, StateShipsUser1)
          Else
              Shoot(InputCoordinates(CoordEdit.Text), StateOfBattleFieldUser2, StateShipsUser2);
      If Not IsHit Then
      Begin
          IsHit := True;
          SwitchPlayers();
      End;
end;

Procedure TMainForm.SwitchPlayers();
Begin
    If(StringGridUser1.Visible = True) Then
    Begin
        StringGridUser1.Visible := False;
        StringGridUser2.Visible := True;
        WhoPlayLabel.Caption := 'Играет второй игрок';
        IsFirstPlayer := False;

    End
    Else
    Begin
        StringGridUser1.Visible := True;
        StringGridUser2.Visible := False;
        WhoPlayLabel.Caption := 'Играет первый игрок';
        IsFirstPlayer := True;
    End;
End;

end.
