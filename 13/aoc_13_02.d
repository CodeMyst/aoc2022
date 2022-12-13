import std.stdio;
import std.json;
import std.file;
import std.string;
import std.algorithm;

void main()
{
    const packetRaw = readText("input").splitLines();

    auto div1 = parseJSON("[[2]]");
    auto div2 = parseJSON("[[6]]");

    JSONValue[] packets = [div1, div2];

    foreach (raw; packetRaw)
    {
        if (raw.empty) continue;
        packets ~= parseJSON(raw);
    }

    packets.sort!((a, b) => comparePackets(b, a) < 1);

    int res = 1;

    foreach (i, packet; packets) if (packet == div1 || packet == div2) res *= i + 1;

    writeln(res);
}

int comparePackets(JSONValue left, JSONValue right)
{
    if (left.isArr && right.isArr)
    {
        int i = 0;
        for (i = 0; i < left.array.length; i++)
        {
            if (i + 1 > right.array.length) return -1;

            const check = comparePackets(left.array[i], right.array[i]);

            if (check != 0) return check; 
        }

        if (right.array.length > i) return 1;
        return 0;
    }
    else if (left.isInt && right.isInt)
    {
        if (left.integer < right.integer) return 1;
        if (left.integer > right.integer) return -1;
        return 0;
    }
    else
    {
        const l = left.isArr ? left : JSONValue([left]);
        const r = right.isArr ? right : JSONValue([right]);

        return comparePackets(l, r);
    }

    return -1;
}

bool isInt(const JSONValue j)
{
    return j.type == JSONType.integer;
}

bool isArr(const JSONValue j)
{
    return j.type == JSONType.array;
}
