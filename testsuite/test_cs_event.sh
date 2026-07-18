#!/bin/bash

cat <<EOF > test_event.cs 
event EventHandler Event;
public event EventHandler MyEvent;
public event EventHandler<string> MessageEvent;
public event Action<int, int> CalculationEvent;
public static event EventHandler StaticEvent;
public virtual event EventHandler VirtualEvent;
public sealed override event EventHandler OverriddenEvent;
public abstract event EventHandler AbstractEvent;
public event EventHandler E1;
protected event EventHandler E2;
internal event EventHandler E3;
private event EventHandler E4;

//TODO - Needs supported in srcML first
/*public event EventHandler MyEvent
{
    add
    {
        _myEvent += value;
    }
    remove
    {
        _myEvent -= value;
    }
}*/
EOF

input=$(srcml test_event.cs  --position)
output=$(echo "$input" | ./nameCollector )
expected="Event is a EventHandler event in C# file: test_event.cs:1:20
Event is a EventHandler event in C# file: test_event.cs:1:20
MyEvent is a EventHandler event in C# file: test_event.cs:2:20
MessageEvent is a EventHandler<string> event in C# file: test_event.cs:3:20
CalculationEvent is a Action<int, int> event in C# file: test_event.cs:4:20
StaticEvent is a EventHandler event in C# file: test_event.cs:5:20
VirtualEvent is a EventHandler event in C# file: test_event.cs:6:20
OverriddenEvent is a EventHandler event in C# file: test_event.cs:7:20
AbstractEvent is a EventHandler event in C# file: test_event.cs:8:20
E1 is a EventHandler event in C# file: test_event.cs:9:20
E2 is a EventHandler event in C# file: test_event.cs:10:20
E3 is a EventHandler event in C# file: test_event.cs:11:20
E4 is a EventHandler event in C# file: test_event.cs:12:20"



if [[ "$output" != "$expected" ]]; then
    echo "Test test_cs_event output did not match expected!" 
    echo "Expected: '$expected'"
    echo "Got:      '$output'"
    exit 1
fi
echo "Test test_cs_event passed!"
# Repeat tests

exit 0