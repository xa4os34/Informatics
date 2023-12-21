const r = 35.0;
const a = 35.0;
const b = 25.0;
const circleXProjection = -33.0; 
const circleYIntersection = -39.0; 
const ellipseYIntersectin = -30.0; 
const ellipseXProjection = -43.0; 

function GetSecondCoordinateOfCircle(coordinate, radius : real) : real; begin
    Result := sqrt(sqr(radius) - sqr(coordinate));
end;

function GetSecondCoordinateOfEllipse(coordinate, radius1, radius2 : real) : real; begin
    Result := radius1 * sqrt(1 - sqr(coordinate / radius2));
end;

begin 
    var dx := 0.001;
    while true do begin
        print('введите dx: ');
        read(dx);
    
        var circleX := circleXProjection + r; 
        var circleY := circleYIntersection + GetSecondCoordinateOfCircle(-circleX, r); 
    
        var ellipseX := ellipseXProjection + b; 
        var ellipseY := ellipseYIntersectin + GetSecondCoordinateOfEllipse(-ellipseX, a, b); 
        println(circleX, circleY);
        println(ellipseX, ellipseY);
         
        var ellipseLineXIntersection := ellipseX + GetSecondCoordinateOfEllipse(-ellipseY, a, b); 
        println(ellipseLineXIntersection);       
        var circleEllipseIntersectionX := circleXProjection;
        var circleEllipseIntersectionY := circleY - GetSecondCoordinateOfCircle(circleEllipseIntersectionX - circleX, r);
    
        while sqr((circleEllipseIntersectionX - ellipseX) / a) + sqr((circleEllipseIntersectionY - ellipseY) / b) < 1 do begin 
            circleEllipseIntersectionX += dx;
            circleEllipseIntersectionY := circleY - GetSecondCoordinateOfCircle(circleEllipseIntersectionX - circleX, r);
    	end;
        
    	var k := -circleEllipseIntersectionY / (ellipseLineXIntersection - circleEllipseIntersectionX); 
    	var c := - k * ellipseLineXIntersection;
        println(k,c);
        var circleEllipseIntersectionX2 := circleXProjection;
        var circleEllipseIntersectionY2 := circleY + GetSecondCoordinateOfCircle(circleEllipseIntersectionX2 - circleX, r);
    
        while sqr((circleEllipseIntersectionX2 - ellipseX) / a) + sqr((circleEllipseIntersectionY2 - ellipseY) / b) < 1 do begin 
            circleEllipseIntersectionX2 += dx;
            circleEllipseIntersectionY2 := circleY + GetSecondCoordinateOfCircle(circleEllipseIntersectionX2 - circleX, r);
    	end;
    
        var circleLineIntersectionX := (sqrt(-circleY**2 + (2 * k * circleX +  2 * c) * circleY - k**2 * circleX**2 - 2 * c * k * circleX + R**2 * k**2 - c**2 + R**2) + k * circleY + circleX - c * k)/(k**2 + 1);
        var circleLineIntersectionY := k * circleLineIntersectionX + c;
    
        writelnformat('dx = {0}', dx);
    
        writeln('┏━━━━━━━━┳━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━┓');
        writeln('┃  name  ┃ Analytical Method ┃Computation Method ┃');
        writeln('┃   of   ┣━━━━━━━━━┳━━━━━━━━━╋━━━━━━━━━┳━━━━━━━━━┫');
        writeln('┃  point ┃    X    ┃    Y    ┃    X    ┃    Y    ┃');
        writeln('┣━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━┫');
        writelnformat('┃   A    ┃ -07.000 ┃  20.000 ┃ {0: 00.000;-00.000} ┃ {1: 00.000;-00.000} ┃', 
            circleEllipseIntersectionX, circleEllipseIntersectionY);
        writeln('┣━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━┫');
        writelnformat('┃   B    ┃  08.000 ┃ -35.000 ┃ {0: 00.000;-00.000} ┃ {1: 00.000;-00.000} ┃',
            circleEllipseIntersectionX2, circleEllipseIntersectionY2);
        writeln('┣━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━╋━━━━━━━━━┫');
        writelnformat('┃   C    ┃  35.000 ┃ -10.000 ┃ {0: 00.000;-00.000} ┃ {1: 00.000;-00.000} ┃',
            circleLineIntersectionX, circleLineIntersectionY);
        writeln('┗━━━━━━━━┻━━━━━━━━━┻━━━━━━━━━┻━━━━━━━━━┻━━━━━━━━━┛');
    end;
end.
