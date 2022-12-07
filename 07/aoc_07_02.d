import std.stdio;
import std.file;
import std.array;
import std.string;
import std.algorithm;
import std.container;
import std.conv;
import std.range;
import std.typecons;

class FileTree
{
    public FileTree parent;
    public FileTree[] sub;

    public string name;
    public bool dir;
    public int size;

    public this(string name, bool dir, int size, FileTree parent)
    {
        this.name = name;
        this.dir = dir;
        this.size = size;
        this.parent = parent;
    }
}

void main()
{
    FileTree tree = new FileTree("/", true, 0, null);

    const input = readText("input");

    foreach (line; input.splitLines()[1..$])
    {
        if (line[0] == '$')
        {
            if (line.startsWith("$ cd"))
            {
                tree = changeDir(tree, line["$ cd ".length..$]);
            }
        }
        else
        {
            const s = line.split();

            if (s[0] == "dir")
            {
                tree.sub ~= new FileTree(s[1], true, 0, tree);
            }
            else
            {
                tree.sub ~= new FileTree(s[1], false, s[0].to!int(), tree);
            }
        }
    }

    tree = goToRoot(tree);
    printTree(tree);

    int totalSpace = dirSize(tree);
    int required = 30_000_000 - (70_000_000 - totalSpace);

    int smallest = int.max;
    foreach (dir; candidates(tree, required))
    {
        int dirSize = dirSize(dir);
        if (dirSize < smallest) smallest = dirSize;
    }

    writeln(smallest);
}

FileTree changeDir(FileTree tree, string dir)
{
    if (dir == "..")
    {
        return tree.parent;
    }

    foreach (s; tree.sub)
    {
        if (s.dir && s.name == dir) return s;
    }

    return null;
}

FileTree goToRoot(FileTree tree)
{
    FileTree parent = tree;
    do
    {
        parent = parent.parent;
    } while (parent.name != "/");

    return parent;
}

FileTree[] candidates(FileTree root, int required)
{
    FileTree[] res;

    foreach (sub; root.sub)
    {
        if (sub.dir)
        {
            if (dirSize(sub) >= required) res ~= sub;

            res ~= candidates(sub, required);
        }
    }

    return res;
}

int dirSize(FileTree tree)
{
    int sum = 0;

    foreach (sub; tree.sub)
    {
        if (sub.dir) sum += dirSize(sub);
        else sum += sub.size;
    }

    return sum;
}

void printTree(FileTree tree, int level = 0)
{
    foreach (i; 0..level) write("  ");
    write("- ");
    writeln(tree.name ~ (tree.dir ? " (dir)" : " (file, size=" ~ tree.size.to!string() ~ ")"));

    foreach (s; tree.sub)
    {
        printTree(s, level + 1);
    }
}
