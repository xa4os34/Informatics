const r = 35.0;
const a = 35.0;
const b = 25.0;
const circleX = 2;
const circleY = -4.057;
const ellipseX = -18;
const ellipseY = -5.711;
const circleXProjection = -33;
const k = -0.831243320779365;
const c = -13.36187068043;
const circleEllipseIntersectionX = -20.776;
const ellipseLineXIntersection = 16.075;
const circleLineXIntersection = 32.290;
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
        x -> circleY - sqrt(r**2 - (x - circleX)**2),
        circleXProjection, circleEllipseIntersectionX,
        iterations);

    aArea += GetAreaUnderCurve(
        x -> k * x + c,
        circleEllipseIntersectionX, 0,
        iterations);

    Result := aArea;
end;

function GetBArea(
    iterations : Integer; 
    getAreaUnderCurve : CalculatingAreaFunction)
    : Double;
begin
    var bArea := getAreaUnderCurve(
        x -> circleY + sqrt(r**2 - (x - circleX)**2),
        0, circleLineXIntersection,
        iterations);

    bArea -= abs( k * (ellipseLineXIntersection + circleLineXIntersection) + c);

    bArea -= getAreaUnderCurve(
        x -> -(b * sqrt(a**2 - (x - ellipseX)**2) - a * ellipseY) / a, 
        0, ellipseLineXIntersection, 
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
