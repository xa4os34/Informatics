const r = 30.0;
const a = 23.0;
const b = 38.0;
const circleX = -7.7157287525381;
const circleY = -10;
const ellipseX = 13.0318780471981;
const ellipseY = 2;
const k = -0.719447193774024;
const c = 14.779801779947;
const circleEllipseIntersectionX = -7.225;
const circleEllipseIntersectionY = 19.996;
const circleEllipseIntersectionX2 = 8.485;
const circleEllipseIntersectionY2 = -35.249;
const ellipseLineXIntersection = 34.806;
const circleLineXIntersection = 20.5685424949238;
const formatA = ':0000.000';
const formatB = ':000.0000';

function CalculateAreaUnderCurveByRect(
    func : Func<Double, Double>;
    lowerBound, upperBound : Double;
    iterations : Integer)
    : Double;
begin
    var currentArea : real = 0;
	for var i := 0 to iterations - 1 do begin
        var functionValue := func((upperBound - lowerBound) / iterations * i + lowerBound);
        currentArea := currentArea + (upperBound - lowerBound) / iterations * functionValue;
	end;

	Result := abs(currentArea);
end;

function CalculateAreaUnderCurveByTrapezoid(
    func : Func<Double, Double>;
    lowerBound, upperBound : Double;
    iterations : Integer)
    : Double;
begin
    var currentArea : real = 0;
    var previouseValue := func(0);
    var dx := (upperBound - lowerBound) / iterations;
	for var i := 1 to iterations - 2 do begin
        currentArea += func(dx * i + lowerBound);
	end;

	Result := abs((currentArea + (func(lowerBound) + func(upperBound)) / 2) * dx);
end;

function GetAArea(
    iterations : Integer; 
    GetAreaUnderCurve : System.Func<Func<Double, Double>, Double, Double, Integer, Double>) 
    : Double;
begin
    var aArea := GetAreaUnderCurve(
        x -> circleY - sqrt(r**2 - (x - circleX)**2),
        circleX - r, 0,
        iterations);

    aArea += GetAreaUnderCurve(
        y -> circleX - sqrt(r**2 - (y - circleY)**2),
        circleY, 0, 
        iterations);

    aArea -= GetAreaUnderCurve(
        x -> ellipseY - a / b * sqrt(b**2 - (x - ellipseX)**2),
        ellipseX - a, 0,
        iterations);

    aArea -= (-circleX + r) * -circleY;

    Result := aArea;
end;

function GetBArea(
    iterations : Integer; 
    getAreaUnderCurve : System.Func<Func<Double, Double>, Double, Double, Integer, Double>) 
    : Double;
begin
    var bArea := getAreaUnderCurve(x -> k * x + c, circleX, 2, iterations);
    bArea += getAreaUnderCurve(
        x -> ellipseY - a / b * sqrt(b**2 - (x - ellipseX)**2), 
        circleEllipseIntersectionX2, 
        ellipseLineXIntersection, 
        iterations); 

    bArea -= getAreaUnderCurve(
        x -> circleY - sqrt(r**2 - (x - circleX)**2),
        circleEllipseIntersectionX2,
        circleLineXIntersection,
        iterations);

    Result := bArea;
end;

begin 
    var tableBuilder := new StringBuilder();

    tableBuilder
        .AppendLine('┏━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━┓')
    	.AppendLine('┃  Itera-  ┃        Area A       ┃        Area B       ┃')
    	.AppendLine('┃  tions   ┣━━━━━━━━━━┳━━━━━━━━━━╋━━━━━━━━━━┳━━━━━━━━━━┫')
    	.AppendLine('┃          ┃Rectangle ┃Trapezoid ┃Rectangle ┃Trapezoid ┃');
    
    for var i := 1 to ParamCount do begin
        var iterations : Integer;

        if not Integer.TryParse(ParamStr(i), iterations) then
            continue;

        var aAreaByRect := GetAArea(
            iterations,
            CalculateAreaUnderCurveByRect); 

        var aAreaByTrapezoid := GetAArea(
            iterations,
            CalculateAreaUnderCurveByTrapezoid); 
    
        var bAreaByRect := GetBArea(
            iterations,
            CalculateAreaUnderCurveByRect);

        var bAreaByTrapezoid := GetBArea(
            iterations,
            CalculateAreaUnderCurveByTrapezoid); 

        tableBuilder.AppendLine('┣━━━━━━━━━━╋━━━━━━━━━━╋━━━━━━━━━━╋━━━━━━━━━━╋━━━━━━━━━━┫')
            .AppendLine(string.Format(
                '┃ {0,-8} ┃ {1'+formatA+'} ┃ {2'+formatA+'} ┃ {3'+formatB+'} ┃ {4'+formatB+'} ┃',
                iterations, aAreaByRect, aAreaByTrapezoid, bAreaByRect, bAreaByTrapezoid));

        iterations *= 10;
    end;

    tableBuilder.AppendLine('┗━━━━━━━━━━┻━━━━━━━━━━┻━━━━━━━━━━┻━━━━━━━━━━┻━━━━━━━━━━┛');

    writeln(tableBuilder.ToString());
end.
