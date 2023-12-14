const r = 31.0;
const a = 31.0;
const b = 38.0;
const circleXProjection = 32.0; 
const circleYIntersection = -20.0; 
const ellipseXIntersectin = -40.0; 
const ellipseYProjection = -45.0; 

function GetSecondCoordinateOfCircle(coordinate, radius : real) : real; begin
    Result := sqrt(sqr(radius) - sqr(coordinate));
end;

function GetSecondCoordinateOfEllipse(coordinate, radius1, radius2 : real) : real; begin
    Result := radius1 * sqrt(1 - sqr(coordinate / radius2));
end;

begin 
    var dx : real;
    if (ParamCount <> 1) or not real.TryParse(ParamStr(1), dx) then 
        dx := 0.001;

    var circleX := circleXProjection - r; 
    var circleY := circleYIntersection + GetSecondCoordinateOfCircle(circleX, r); 

    var ellipseY := ellipseYProjection + b; 
    var ellipseX := ellipseXIntersectin + GetSecondCoordinateOfEllipse(ellipseY, a, b); 

    var ellipseLineXIntersection := ellipseX + GetSecondCoordinateOfEllipse(ellipseY, a, b); 

    var circleEllipseIntersectionX := circleXProjection;
    var circleEllipseIntersectionY := circleY + GetSecondCoordinateOfCircle(circleEllipseIntersectionX - circleX, r);

    while sqr((circleEllipseIntersectionX - ellipseX) / a) + sqr((circleEllipseIntersectionY - ellipseY) / b) > 1 do begin 
        circleEllipseIntersectionX -= dx;
        circleEllipseIntersectionY := circleY + GetSecondCoordinateOfCircle(circleEllipseIntersectionX - circleX, r);
    end;

    writelnformat('dx = {0}', dx);

    writeln('┏━━━━━━━━┳━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━┓');
    writeln('┃  name  ┃ Analytical Method ┃Computation Method ┃');
    writeln('┃   of   ┣━━━━━━━━━┳━━━━━━━━━╋━━━━━━━━━┳━━━━━━━━━┫');
    writeln('┃  point ┃    X    ┃    Y    ┃    X    ┃    Y    ┃');
    writeln('┣━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━┫');
    writelnformat('┃   A    ┃ -27.000 ┃  24.500 ┃ {0: 00.000;-00.000} ┃ {1: 00.000;-00.000} ┃', 
        circleEllipseIntersectionX, circleEllipseIntersectionY);
    writeln('┗━━━━━━━━┻━━━━━━━━━┻━━━━━━━━━┻━━━━━━━━━┻━━━━━━━━━┛');
end.
