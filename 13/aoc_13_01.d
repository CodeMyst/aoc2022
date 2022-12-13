import std.stdio;
import std.json;
import std.file;
import std.string;

void main()
{
    const pairs = readText("input").split("\n\n");

    int sum = 0;

    foreach (i, pair; pairs)
    {
        const splitPair = pair.split("\n");
        const p1 = parseJSON(splitPair[0]);
        const p2 = parseJSON(splitPair[1]);

        const res = comparePackets(p1, p2) == 1; 

        if (res) sum += i + 1;
    }

    writeln(sum);
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
