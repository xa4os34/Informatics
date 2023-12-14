const r = 31.0;
const a = 31.0;
const b = 38.0;
const circleX = 1;
const circleY = 10.983866769653;
const ellipseX = -9.53050887860652;
const ellipseY = -7;
const circleXProjection = 32;
const k = -0.511116980777037;
const c = 10.7022693844773;
const circleEllipseIntersectionX = -26.9174999998894;
const circleEllipseIntersectionY = 24.4602607144866;
const ellipseLineXIntersection = 20.938982242787;
const formatA = ':000.0000';
const formatB = ':000.0000';

type CalculatingAreaFunction = function(
    func : Func<Double, Double>;
    lowerBound, upperBound : Double; 
    iterations : Integer) : Double;

function CalculateAreaUnderCurveByRect(
    func : Func<Double, Double>;
    lowerBound, upperBound : Double;
    iterations : Integer)
    : Double;
begin
    var area : real = 0;
    var dx := (upperBound - lowerBound) / iterations;
    for var i := 0 to iterations - 1 do begin
        area += dx * func(dx * i + lowerBound)
    end;

    Result := abs(area);
end;

function CalculateAreaUnderCurveByTrapezoid(
    func : Func<Double, Double>;
    lowerBound, upperBound : Double;
    iterations : Integer)
    : Double;
begin
    var area : real = 0;
    var previouseValue := func(0);
    var dx := (upperBound - lowerBound) / iterations;

    for var i := 1 to iterations - 2 do begin
        area += func(dx * i + lowerBound);
    end;

    area += (func(lowerBound) + func(upperBound)) / 2;
    Result := abs(area * dx);
end;

function GetAArea(
    iterations : Integer; 
    GetAreaUnderCurve : CalculatingAreaFunction) 
    : Double;
begin
    var aArea := GetAreaUnderCurve(
        x -> k * x + c,
        circleEllipseIntersectionX, 0,
        iterations);

    aArea += GetAreaUnderCurve(
        y -> circleX - sqrt(r**2 - (y - circleY)**2),
        0, circleEllipseIntersectionY, 
        iterations);

    aArea -= abs(circleEllipseIntersectionX * circleEllipseIntersectionY);

    Result := aArea;
end;

function GetBArea(
    iterations : Integer; 
    getAreaUnderCurve : CalculatingAreaFunction)
    : Double;
begin
    var bArea := getAreaUnderCurve(
        x -> circleY + sqrt(r**2 - (x - circleX)**2),
        0, circleXProjection,
        iterations);

    bArea += getAreaUnderCurve(
        y -> circleX + sqrt(r**2 - (y - circleY)**2), 
        0, circleY, 
        iterations); 

    bArea -= getAreaUnderCurve(
        x -> ellipseY - a / b * sqrt(b**2 - (x - ellipseX)**2),
        0, ellipseLineXIntersection,
        iterations);

    bArea -= circleY * circleXProjection;

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
