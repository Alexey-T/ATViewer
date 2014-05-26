// Point in rect
function IsPointIn(P: TPoint; R: TRect): Boolean;
begin
  Result := (P.X >= R.Left) and (P.X <= R.Right) and (P.Y >= R.Top) and (P.Y <= R.Bottom);
end;

//Rect empty
function IsRect0(const r: TRect): Boolean;
begin
  Result := (r.right - r.Left <= 0) or (r.bottom - r.top <= 0);
end;

//Rects interchange
function IsRectChg(R1, R2: TRect): Boolean;
begin
  if IsRect0(R1) or IsRect0(R2) then Result := False
  else
  if IsPointIn(Point(R1.Left, R1.Top), R2) then Result:= True
  else
  if R1.Left >= R2.Right then Result:= False
  else
  if R1.Top >= R2.Bottom then Result:= False
  else
  if (R1.Right > R2.Left) and (R1.Bottom > R2.Top) then Result:= True
  else
  Result := False;
end;
