#!/bin/bash

# test the collection of names with and without position markers from an example class 'set' 

#####################################################################
cat <<EOF > set.xml
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<unit xmlns="http://www.srcML.org/srcML/src" revision="1.0.0" url="src/">

<unit xmlns:cpp="http://www.srcML.org/srcML/cpp" revision="1.0.0" language="C++" filename="test_set.cpp" hash="34ec4fedd6c0db19d102d029d31e16f6720cc4d0"><cpp:include>#<cpp:directive>include</cpp:directive> <cpp:file>"test_set.hpp"</cpp:file></cpp:include>
<cpp:include>#<cpp:directive>include</cpp:directive> <cpp:file>&lt;iostream&gt;</cpp:file></cpp:include>

<constructor><name><name>Set</name><operator>::</operator><name>Set</name></name><parameter_list>()</parameter_list> <block>{<block_content>
    <for>for <control>(<init><decl><type><name>int</name></type> <name>i</name> <init>= <expr><literal type="number">0</literal></expr></init></decl>;</init> <condition><expr><name>i</name> <operator>&lt;</operator> <name>COLLECTION_SIZE</name></expr>;</condition> <incr><expr><operator>++</operator><name>i</name></expr></incr>)</control> <block>{<block_content>
        <expr_stmt><expr><name><name>member</name><index>[<expr><name>i</name></expr>]</index></name> <operator>=</operator> <literal type="boolean">false</literal></expr>;</expr_stmt>
    </block_content>}</block></for>
</block_content>}</block></constructor>

<constructor><name><name>Set</name><operator>::</operator><name>Set</name></name><parameter_list>(<parameter><decl><type><name>int</name></type> <name>x</name></decl></parameter>)</parameter_list> <member_init_list>: <call><name>Set</name><argument_list>()</argument_list></call> </member_init_list><block>{<block_content>
    <expr_stmt><expr><name><name>member</name><index>[<expr><name>x</name></expr>]</index></name> <operator>=</operator> <literal type="boolean">true</literal></expr>;</expr_stmt>
</block_content>}</block></constructor>

<function><type><name>unsigned</name> <name>int</name></type> <name><name>Set</name><operator>::</operator><name>cardinality</name></name><parameter_list>()</parameter_list> <specifier>const</specifier> <block>{<block_content>
    <decl_stmt><decl><type><name>unsigned</name> <name>int</name></type> <name>card</name> <init>= <expr><literal type="number">0</literal></expr></init></decl>;</decl_stmt>
    <for>for<control>(<init><decl><type><name>size_t</name></type> <name>i</name> <init>= <expr><literal type="number">0</literal></expr></init></decl>;</init> <condition><expr><name>i</name> <operator>&lt;</operator> <name>COLLECTION_SIZE</name></expr>;</condition> <incr><expr><operator>++</operator><name>i</name></expr></incr>)</control> <block>{<block_content>
        <if_stmt><if>if<condition>(<expr><name><name>member</name><index>[<expr><name>i</name></expr>]</index></name></expr>)</condition> <block>{<block_content>
            <expr_stmt><expr><operator>++</operator><name>card</name></expr>;</expr_stmt>
        </block_content>}</block></if></if_stmt>
    </block_content>}</block></for>
    <return>return <expr><name>card</name></expr>;</return>
</block_content>}</block></function>

<function type="operator"><type><name>Set</name></type> <name><name>Set</name><operator>::</operator><name>operator<name>+</name></name></name><parameter_list>(<parameter><decl><type><specifier>const</specifier> <name>Set</name><modifier>&amp;</modifier></type> <name>rhs</name></decl></parameter>)</parameter_list> <specifier>const</specifier> <block>{<block_content>
    <decl_stmt><decl><type><name>Set</name></type> <name>result</name></decl>;</decl_stmt>
    <for>for<control>(<init><decl><type><name>size_t</name></type> <name>i</name> <init>= <expr><literal type="number">0</literal></expr></init></decl>;</init> <condition><expr><name>i</name> <operator>&lt;</operator> <name>COLLECTION_SIZE</name></expr>;</condition> <incr><expr><operator>++</operator><name>i</name></expr></incr>)</control> <block>{<block_content>
        <expr_stmt><expr><name><name>result</name><operator>.</operator><name>member</name><index>[<expr><name>i</name></expr>]</index></name> <operator>=</operator> <name><name>member</name><index>[<expr><name>i</name></expr>]</index></name> <operator>||</operator> <name><name>rhs</name><operator>.</operator><name>member</name><index>[<expr><name>i</name></expr>]</index></name></expr>;</expr_stmt>
    </block_content>}</block></for>
    <return>return <expr><name>result</name></expr>;</return>
</block_content>}</block></function>

<function type="operator"><type><name>Set</name></type> <name><name>Set</name><operator>::</operator><name>operator<name>*</name></name></name><parameter_list>(<parameter><decl><type><specifier>const</specifier> <name>Set</name><modifier>&amp;</modifier></type> <name>rhs</name></decl></parameter>)</parameter_list> <specifier>const</specifier> <block>{<block_content>
    <decl_stmt><decl><type><name>Set</name></type> <name>result</name></decl>;</decl_stmt>
    <for>for<control>(<init><decl><type><name>size_t</name></type> <name>i</name> <init>= <expr><literal type="number">0</literal></expr></init></decl>;</init> <condition><expr><name>i</name> <operator>&lt;</operator> <name>COLLECTION_SIZE</name></expr>;</condition> <incr><expr><operator>++</operator><name>i</name></expr></incr>)</control> <block>{<block_content>
        <expr_stmt><expr><name><name>result</name><operator>.</operator><name>member</name><index>[<expr><name>i</name></expr>]</index></name> <operator>=</operator> <name><name>member</name><index>[<expr><name>i</name></expr>]</index></name> <operator>&amp;&amp;</operator> <name><name>rhs</name><operator>.</operator><name>member</name><index>[<expr><name>i</name></expr>]</index></name></expr>;</expr_stmt>
    </block_content>}</block></for>
    <return>return <expr><name>result</name></expr>;</return>
</block_content>}</block></function>

<function type="operator"><type><name>Set</name></type> <name><name>Set</name><operator>::</operator><name>operator<name>-</name></name></name><parameter_list>(<parameter><decl><type><specifier>const</specifier> <name>Set</name><modifier>&amp;</modifier></type> <name>rhs</name></decl></parameter>)</parameter_list> <specifier>const</specifier> <block>{<block_content>
    <decl_stmt><decl><type><name>Set</name></type> <name>result</name></decl>;</decl_stmt>
    <for>for<control>(<init><decl><type><name>size_t</name></type> <name>i</name> <init>= <expr><literal type="number">0</literal></expr></init></decl>;</init> <condition><expr><name>i</name> <operator>&lt;</operator> <name>COLLECTION_SIZE</name></expr>;</condition> <incr><expr><operator>++</operator><name>i</name></expr></incr>)</control> <block>{<block_content>
        <expr_stmt><expr><name><name>result</name><operator>.</operator><name>member</name><index>[<expr><name>i</name></expr>]</index></name> <operator>=</operator> <name><name>member</name><index>[<expr><name>i</name></expr>]</index></name> <operator>&amp;&amp;</operator> <operator>!</operator><name><name>rhs</name><operator>.</operator><name>member</name><index>[<expr><name>i</name></expr>]</index></name></expr>;</expr_stmt>
    </block_content>}</block></for>
    <return>return <expr><name>result</name></expr>;</return>
</block_content>}</block></function>

<function type="operator"><type><name>Set</name></type> <name><name>Set</name><operator>::</operator><name>operator<name>~</name></name></name><parameter_list>()</parameter_list> <specifier>const</specifier> <block>{<block_content>
    <decl_stmt><decl><type><name>Set</name></type> <name>result</name></decl>;</decl_stmt>
    <for>for<control>(<init><decl><type><name>size_t</name></type> <name>i</name> <init>= <expr><literal type="number">0</literal></expr></init></decl>;</init> <condition><expr><name>i</name> <operator>&lt;</operator> <name>COLLECTION_SIZE</name></expr>;</condition> <incr><expr><operator>++</operator><name>i</name></expr></incr>)</control> <block>{<block_content>
        <expr_stmt><expr><name><name>result</name><operator>.</operator><name>member</name><index>[<expr><name>i</name></expr>]</index></name> <operator>=</operator> <operator>!</operator><name><name>member</name><index>[<expr><name>i</name></expr>]</index></name></expr>;</expr_stmt>
    </block_content>}</block></for>
    <return>return <expr><name>result</name></expr>;</return>
</block_content>}</block></function>

<function type="operator"><type><name>bool</name></type> <name><name>Set</name><operator>::</operator><name>operator<name>==</name></name></name><parameter_list>(<parameter><decl><type><specifier>const</specifier> <name>Set</name><modifier>&amp;</modifier></type> <name>rhs</name></decl></parameter>)</parameter_list> <specifier>const</specifier> <block>{<block_content>
    <for>for<control>(<init><decl><type><name>size_t</name></type> <name>i</name> <init>= <expr><literal type="number">0</literal></expr></init></decl>;</init> <condition><expr><name>i</name> <operator>&lt;</operator> <name>COLLECTION_SIZE</name></expr>;</condition> <incr><expr><operator>++</operator><name>i</name></expr></incr>)</control> <block>{<block_content>
        <if_stmt><if>if<condition>(<expr><name><name>member</name><index>[<expr><name>i</name></expr>]</index></name> <operator>!=</operator> <name><name>rhs</name><operator>.</operator><name>member</name><index>[<expr><name>i</name></expr>]</index></name></expr>)</condition> <block>{<block_content>
            <return>return <expr><literal type="boolean">false</literal></expr>;</return>
        </block_content>}</block></if></if_stmt>
    </block_content>}</block></for>
    <return>return <expr><literal type="boolean">true</literal></expr>;</return>
</block_content>}</block></function>

<function type="operator"><type><name>bool</name></type> <name><name>Set</name><operator>::</operator><name>operator<name>&lt;=</name></name></name><parameter_list>(<parameter><decl><type><specifier>const</specifier> <name>Set</name><modifier>&amp;</modifier></type> <name>rhs</name></decl></parameter>)</parameter_list> <specifier>const</specifier> <block>{<block_content>
    <for>for<control>(<init><decl><type><name>size_t</name></type> <name>i</name> <init>= <expr><literal type="number">0</literal></expr></init></decl>;</init> <condition><expr><name>i</name> <operator>&lt;</operator> <name>COLLECTION_SIZE</name></expr>;</condition> <incr><expr><operator>++</operator><name>i</name></expr></incr>)</control> <block>{<block_content>
        <if_stmt><if>if<condition>(<expr><name><name>member</name><index>[<expr><name>i</name></expr>]</index></name> <operator>&amp;&amp;</operator> <operator>!</operator><name><name>rhs</name><operator>.</operator><name>member</name><index>[<expr><name>i</name></expr>]</index></name></expr>)</condition> <block>{<block_content>
            <return>return <expr><literal type="boolean">false</literal></expr>;</return>
        </block_content>}</block></if></if_stmt>
    </block_content>}</block></for>
    <return>return <expr><literal type="boolean">true</literal></expr>;</return>
</block_content>}</block></function>

<function type="operator"><type><name><name>std</name><operator>::</operator><name>ostream</name></name><modifier>&amp;</modifier></type> <name>operator<name>&lt;&lt;</name></name><parameter_list>(<parameter><decl><type><name><name>std</name><operator>::</operator><name>ostream</name></name><modifier>&amp;</modifier></type> <name>out</name></decl></parameter>, <parameter><decl><type><specifier>const</specifier> <name>Set</name><modifier>&amp;</modifier></type> <name>rhs</name></decl></parameter>)</parameter_list> <block>{<block_content>
    <expr_stmt><expr><name>out</name> <operator>&lt;&lt;</operator> <literal type="string">"set( "</literal></expr>;</expr_stmt>
    <for>for<control>(<init><decl><type><name>size_t</name></type> <name>i</name> <init>= <expr><literal type="number">0</literal></expr></init></decl>;</init> <condition><expr><name>i</name> <operator>&lt;</operator> <name>COLLECTION_SIZE</name></expr>;</condition> <incr><expr><operator>++</operator><name>i</name></expr></incr>)</control> <block>{<block_content>
        <if_stmt><if>if<condition>(<expr><name><name>rhs</name><operator>.</operator><name>member</name><index>[<expr><name>i</name></expr>]</index></name></expr>)</condition> <block>{<block_content>
            <expr_stmt><expr><name>out</name> <operator>&lt;&lt;</operator> <name>i</name> <operator>&lt;&lt;</operator> <literal type="char">' '</literal></expr>;</expr_stmt>
        </block_content>}</block></if></if_stmt>
    </block_content>}</block></for>
    <expr_stmt><expr><name>out</name> <operator>&lt;&lt;</operator> <literal type="string">")"</literal></expr>;</expr_stmt>
    <return>return <expr><name>out</name></expr>;</return>
</block_content>}</block></function>

<function type="operator"><type><name>bool</name></type> <name>operator<name>!=</name></name><parameter_list>(<parameter><decl><type><specifier>const</specifier> <name>Set</name><modifier>&amp;</modifier></type> <name>lhs</name></decl></parameter>, <parameter><decl><type><specifier>const</specifier> <name>Set</name><modifier>&amp;</modifier></type> <name>rhs</name></decl></parameter>)</parameter_list> <block>{<block_content>
    <return>return <expr><operator>!</operator><operator>(</operator><name>lhs</name> <operator>==</operator> <name>rhs</name><operator>)</operator></expr>;</return>
</block_content>}</block></function>
<function type="operator"><type><name>bool</name></type> <name>operator<name>&lt;</name></name> <parameter_list>(<parameter><decl><type><specifier>const</specifier> <name>Set</name><modifier>&amp;</modifier></type> <name>lhs</name></decl></parameter>, <parameter><decl><type><specifier>const</specifier> <name>Set</name><modifier>&amp;</modifier></type> <name>rhs</name></decl></parameter>)</parameter_list> <block>{<block_content>
    <return>return <expr><name>rhs</name> <operator>&gt;</operator> <name>lhs</name></expr>;</return>
</block_content>}</block></function>
<function type="operator"><type><name>bool</name></type> <name>operator<name>&gt;=</name></name><parameter_list>(<parameter><decl><type><specifier>const</specifier> <name>Set</name><modifier>&amp;</modifier></type> <name>lhs</name></decl></parameter>, <parameter><decl><type><specifier>const</specifier> <name>Set</name><modifier>&amp;</modifier></type> <name>rhs</name></decl></parameter>)</parameter_list> <block>{<block_content>
    <return>return <expr><name>rhs</name> <operator>&lt;=</operator> <name>lhs</name></expr>;</return>
</block_content>}</block></function>
<function type="operator"><type><name>bool</name></type> <name>operator<name>&gt;</name></name> <parameter_list>(<parameter><decl><type><specifier>const</specifier> <name>Set</name><modifier>&amp;</modifier></type> <name>lhs</name></decl></parameter>, <parameter><decl><type><specifier>const</specifier> <name>Set</name><modifier>&amp;</modifier></type> <name>rhs</name></decl></parameter>)</parameter_list> <block>{<block_content>
    <return>return <expr><operator>!</operator><operator>(</operator><name>lhs</name> <operator>&lt;=</operator> <name>rhs</name><operator>)</operator></expr>;</return>
</block_content>}</block></function>

</unit>

<unit xmlns:cpp="http://www.srcML.org/srcML/cpp" revision="1.0.0" language="C++" filename="test_set.hpp" hash="d69ede479064a9957a2bfd1d21876fcd4caf70cb"><cpp:ifndef>#<cpp:directive>ifndef</cpp:directive> <name>NAMECOLLECTOR_SET_HPP_</name></cpp:ifndef>
<cpp:define>#<cpp:directive>define</cpp:directive> <cpp:macro><name>NAMECOLLECTOR_SET_HPP_</name></cpp:macro></cpp:define>

<cpp:include>#<cpp:directive>include</cpp:directive> <cpp:file>&lt;iostream&gt;</cpp:file></cpp:include>

<decl_stmt><decl><type><specifier>const</specifier> <name>unsigned</name> <name>int</name></type> <name>COLLECTION_SIZE</name> <init>= <expr><literal type="number">100</literal></expr></init></decl>;</decl_stmt>


<class>class <name>Set</name> <block>{<private type="default">
</private><public>public:
    <constructor_decl><name>Set</name><parameter_list>()</parameter_list>;</constructor_decl>
    <constructor_decl><name>Set</name><parameter_list>(<parameter><decl><type><name>int</name></type></decl></parameter>)</parameter_list>;</constructor_decl>

    <function_decl><type><name>unsigned</name> <name>int</name></type> <name>cardinality</name> <parameter_list>()</parameter_list> <specifier>const</specifier>;</function_decl>
    <function_decl type="operator"><type><name>bool</name></type> <name>operator<name>[]</name></name> <parameter_list>(<parameter><decl><type><name>int</name></type></decl></parameter>)</parameter_list> <specifier>const</specifier>;</function_decl>

    <function_decl type="operator"><type><name>Set</name></type> <name>operator<name>+</name></name><parameter_list>(<parameter><decl><type><specifier>const</specifier> <name>Set</name><modifier>&amp;</modifier></type></decl></parameter>)</parameter_list> <specifier>const</specifier>;</function_decl>
    <function_decl type="operator"><type><name>Set</name></type> <name>operator<name>*</name></name><parameter_list>(<parameter><decl><type><specifier>const</specifier> <name>Set</name><modifier>&amp;</modifier></type></decl></parameter>)</parameter_list> <specifier>const</specifier>;</function_decl>
    <function_decl type="operator"><type><name>Set</name></type> <name>operator<name>-</name></name><parameter_list>(<parameter><decl><type><specifier>const</specifier> <name>Set</name><modifier>&amp;</modifier></type></decl></parameter>)</parameter_list> <specifier>const</specifier>;</function_decl>

    <function_decl type="operator"><type><name>Set</name></type> <name>operator<name>~</name></name><parameter_list>()</parameter_list> <specifier>const</specifier>;</function_decl>

    <function_decl type="operator"><type><name>bool</name></type> <name>operator<name>==</name></name><parameter_list>(<parameter><decl><type><specifier>const</specifier> <name>Set</name><modifier>&amp;</modifier></type></decl></parameter>)</parameter_list> <specifier>const</specifier>;</function_decl>
    <function_decl type="operator"><type><name>bool</name></type> <name>operator<name>&lt;=</name></name><parameter_list>(<parameter><decl><type><specifier>const</specifier> <name>Set</name><modifier>&amp;</modifier></type></decl></parameter>)</parameter_list> <specifier>const</specifier>;</function_decl>

    <friend>friend <function_decl type="operator"><type><name><name>std</name><operator>::</operator><name>ostream</name></name><modifier>&amp;</modifier></type> <name>operator<name>&lt;&lt;</name></name><parameter_list>(<parameter><decl><type><name><name>std</name><operator>::</operator><name>ostream</name></name><modifier>&amp;</modifier></type></decl></parameter>, <parameter><decl><type><specifier>const</specifier> <name>Set</name><modifier>&amp;</modifier></type></decl></parameter>)</parameter_list>;</function_decl></friend>

</public><private>private:
    <decl_stmt><decl><type><name>bool</name></type> <name><name>member</name><index>[<expr><name>COLLECTION_SIZE</name></expr>]</index></name></decl>;</decl_stmt>
</private>}</block>;</class>


<function_decl type="operator"><type><name>bool</name></type> <name>operator<name>!=</name></name><parameter_list>(<parameter><decl><type><specifier>const</specifier> <name>Set</name><modifier>&amp;</modifier></type></decl></parameter>, <parameter><decl><type><specifier>const</specifier> <name>Set</name><modifier>&amp;</modifier></type></decl></parameter>)</parameter_list>;</function_decl>
<function_decl type="operator"><type><name>bool</name></type> <name>operator<name>&lt;</name></name> <parameter_list>(<parameter><decl><type><specifier>const</specifier> <name>Set</name><modifier>&amp;</modifier></type></decl></parameter>, <parameter><decl><type><specifier>const</specifier> <name>Set</name><modifier>&amp;</modifier></type></decl></parameter>)</parameter_list>;</function_decl>
<function_decl type="operator"><type><name>bool</name></type> <name>operator<name>&gt;=</name></name><parameter_list>(<parameter><decl><type><specifier>const</specifier> <name>Set</name><modifier>&amp;</modifier></type></decl></parameter>, <parameter><decl><type><specifier>const</specifier> <name>Set</name><modifier>&amp;</modifier></type></decl></parameter>)</parameter_list>;</function_decl>
<function_decl type="operator"><type><name>bool</name></type> <name>operator<name>&gt;</name></name> <parameter_list>(<parameter><decl><type><specifier>const</specifier> <name>Set</name><modifier>&amp;</modifier></type></decl></parameter>, <parameter><decl><type><specifier>const</specifier> <name>Set</name><modifier>&amp;</modifier></type></decl></parameter>)</parameter_list>;</function_decl>



<cpp:endif>#<cpp:directive>endif</cpp:directive></cpp:endif>
</unit>

<unit xmlns:cpp="http://www.srcML.org/srcML/cpp" revision="1.0.0" language="C++" filename="test_set_main.cpp" hash="e1719eaf257b2c66e5aa5267ff855c4af8d82673"><cpp:include>#<cpp:directive>include</cpp:directive> <cpp:file>"test_set.hpp"</cpp:file></cpp:include>


<function><type><name>int</name></type> <name>main</name><parameter_list>()</parameter_list> <block>{<block_content>
    <decl_stmt><decl><type><name>Set</name></type> <name>x</name></decl>;</decl_stmt>
    <decl_stmt><decl><type><name>Set</name></type> <name>y</name><argument_list>(<argument><expr><literal type="number">10</literal></expr></argument>)</argument_list></decl>;</decl_stmt>
    <expr_stmt><expr><name><name>std</name><operator>::</operator><name>cout</name></name> <operator>&lt;&lt;</operator> <name>x</name> <operator>&lt;&lt;</operator> <name><name>std</name><operator>::</operator><name>endl</name></name></expr>;</expr_stmt>
    <expr_stmt><expr><name><name>std</name><operator>::</operator><name>cout</name></name> <operator>&lt;&lt;</operator> <operator>~</operator><name>x</name> <operator>&lt;&lt;</operator> <name><name>std</name><operator>::</operator><name>endl</name></name></expr>;</expr_stmt>
    <expr_stmt><expr><name><name>std</name><operator>::</operator><name>cout</name></name> <operator>&lt;&lt;</operator> <name>y</name> <operator>&lt;&lt;</operator> <name><name>std</name><operator>::</operator><name>endl</name></name></expr>;</expr_stmt>
    <expr_stmt><expr><name><name>std</name><operator>::</operator><name>cout</name></name> <operator>&lt;&lt;</operator> <operator>~</operator><name>y</name> <operator>&lt;&lt;</operator> <name><name>std</name><operator>::</operator><name>endl</name></name></expr>;</expr_stmt>
    <expr_stmt><expr><name><name>std</name><operator>::</operator><name>cout</name></name> <operator>&lt;&lt;</operator> <name>y</name> <operator>+</operator> <operator>~</operator><name>y</name> <operator>&lt;&lt;</operator> <name><name>std</name><operator>::</operator><name>endl</name></name></expr>;</expr_stmt>
    <expr_stmt><expr><name><name>std</name><operator>::</operator><name>cout</name></name> <operator>&lt;&lt;</operator> <name>y</name> <operator>*</operator> <operator>~</operator><name>y</name> <operator>&lt;&lt;</operator> <name><name>std</name><operator>::</operator><name>endl</name></name></expr>;</expr_stmt>

    <decl_stmt><decl><type><name>Set</name></type> <name>z</name><argument_list>(<argument><expr><literal type="number">14</literal></expr></argument>)</argument_list></decl>;</decl_stmt>

    <decl_stmt><decl><type><name>Set</name></type> <name>a</name> <init>= <expr><name>y</name> <operator>+</operator> <name>z</name></expr></init></decl>;</decl_stmt>
    <expr_stmt><expr><name><name>std</name><operator>::</operator><name>cout</name></name> <operator>&lt;&lt;</operator> <name>a</name> <operator>&lt;&lt;</operator> <name><name>std</name><operator>::</operator><name>endl</name></name></expr>;</expr_stmt>
</block_content>}</block></function>
</unit>

</unit>
EOF

output=$(cat set.xml | ./nameCollector )
expected=$(cat <<EOF
Set is a constructor in C++ file: test_set.cpp
i is a int local in C++ file: test_set.cpp
Set is a constructor in C++ file: test_set.cpp
x is a int parameter in C++ file: test_set.cpp
cardinality is a unsigned int function in C++ file: test_set.cpp
card is a unsigned int local in C++ file: test_set.cpp
i is a size_t local in C++ file: test_set.cpp
operator+ is a Set function in C++ file: test_set.cpp
rhs is a const Set& parameter in C++ file: test_set.cpp
result is a Set local in C++ file: test_set.cpp
i is a size_t local in C++ file: test_set.cpp
operator* is a Set function in C++ file: test_set.cpp
rhs is a const Set& parameter in C++ file: test_set.cpp
result is a Set local in C++ file: test_set.cpp
i is a size_t local in C++ file: test_set.cpp
operator- is a Set function in C++ file: test_set.cpp
rhs is a const Set& parameter in C++ file: test_set.cpp
result is a Set local in C++ file: test_set.cpp
i is a size_t local in C++ file: test_set.cpp
operator~ is a Set function in C++ file: test_set.cpp
result is a Set local in C++ file: test_set.cpp
i is a size_t local in C++ file: test_set.cpp
operator== is a bool function in C++ file: test_set.cpp
rhs is a const Set& parameter in C++ file: test_set.cpp
i is a size_t local in C++ file: test_set.cpp
operator<= is a bool function in C++ file: test_set.cpp
rhs is a const Set& parameter in C++ file: test_set.cpp
i is a size_t local in C++ file: test_set.cpp
operator<< is a std::ostream& function in C++ file: test_set.cpp
out is a std::ostream& parameter in C++ file: test_set.cpp
rhs is a const Set& parameter in C++ file: test_set.cpp
i is a size_t local in C++ file: test_set.cpp
operator!= is a bool function in C++ file: test_set.cpp
lhs is a const Set& parameter in C++ file: test_set.cpp
rhs is a const Set& parameter in C++ file: test_set.cpp
operator< is a bool function in C++ file: test_set.cpp
lhs is a const Set& parameter in C++ file: test_set.cpp
rhs is a const Set& parameter in C++ file: test_set.cpp
operator>= is a bool function in C++ file: test_set.cpp
lhs is a const Set& parameter in C++ file: test_set.cpp
rhs is a const Set& parameter in C++ file: test_set.cpp
operator> is a bool function in C++ file: test_set.cpp
lhs is a const Set& parameter in C++ file: test_set.cpp
rhs is a const Set& parameter in C++ file: test_set.cpp
NAMECOLLECTOR_SET_HPP_ is a macro in C++ file: test_set.hpp
COLLECTION_SIZE is a const unsigned int global in C++ file: test_set.hpp
Set is a class in C++ file: test_set.hpp
Set is a constructor in C++ file: test_set.hpp
Set is a constructor in C++ file: test_set.hpp
cardinality is a unsigned int function in C++ file: test_set.hpp
operator[] is a bool function in C++ file: test_set.hpp
operator+ is a Set function in C++ file: test_set.hpp
operator* is a Set function in C++ file: test_set.hpp
operator- is a Set function in C++ file: test_set.hpp
operator~ is a Set function in C++ file: test_set.hpp
operator== is a bool function in C++ file: test_set.hpp
operator<= is a bool function in C++ file: test_set.hpp
operator<< is a std::ostream& function in C++ file: test_set.hpp
member is a bool field in C++ file: test_set.hpp
operator!= is a bool function in C++ file: test_set.hpp
operator< is a bool function in C++ file: test_set.hpp
operator>= is a bool function in C++ file: test_set.hpp
operator> is a bool function in C++ file: test_set.hpp
main is a int function in C++ file: test_set_main.cpp
x is a Set local in C++ file: test_set_main.cpp
y is a Set local in C++ file: test_set_main.cpp
z is a Set local in C++ file: test_set_main.cpp
a is a Set local in C++ file: test_set_main.cpp
EOF
)
if [[ "$output" != "$expected" ]]; then
    echo "Test set failed!"
    echo "Expected: '$expected'"
    echo "Got:      '$output'"
    exit 1
else 
    echo "Test set passed"
fi


#####################################################################
cat <<EOF > set_pos.xml
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<unit xmlns="http://www.srcML.org/srcML/src" xmlns:pos="http://www.srcML.org/srcML/position" revision="1.0.0" url="src/" pos:tabs="8">

<unit xmlns:cpp="http://www.srcML.org/srcML/cpp" revision="1.0.0" language="C++" filename="test_set.cpp" pos:tabs="8" hash="34ec4fedd6c0db19d102d029d31e16f6720cc4d0"><cpp:include pos:start="1:1" pos:end="1:23">#<cpp:directive pos:start="1:2" pos:end="1:8">include</cpp:directive> <cpp:file pos:start="1:10" pos:end="1:23">"test_set.hpp"</cpp:file></cpp:include>
<cpp:include pos:start="2:1" pos:end="2:19">#<cpp:directive pos:start="2:2" pos:end="2:8">include</cpp:directive> <cpp:file pos:start="2:10" pos:end="2:19">&lt;iostream&gt;</cpp:file></cpp:include>

<constructor pos:start="4:1" pos:end="8:1"><name pos:start="4:1" pos:end="4:8"><name pos:start="4:1" pos:end="4:3">Set</name><operator pos:start="4:4" pos:end="4:5">::</operator><name pos:start="4:6" pos:end="4:8">Set</name></name><parameter_list pos:start="4:9" pos:end="4:10">()</parameter_list> <block pos:start="4:12" pos:end="8:1">{<block_content pos:start="4:13" pos:end="8:0">
    <for pos:start="5:5" pos:end="7:5">for <control pos:start="5:9" pos:end="5:45">(<init pos:start="5:10" pos:end="5:19"><decl pos:start="5:10" pos:end="5:18"><type pos:start="5:10" pos:end="5:12"><name pos:start="5:10" pos:end="5:12">int</name></type> <name pos:start="5:14" pos:end="5:14">i</name> <init pos:start="5:16" pos:end="5:18">= <expr pos:start="5:18" pos:end="5:18"><literal type="number" pos:start="5:18" pos:end="5:18">0</literal></expr></init></decl>;</init> <condition pos:start="5:21" pos:end="5:40"><expr pos:start="5:21" pos:end="5:39"><name pos:start="5:21" pos:end="5:21">i</name> <operator pos:start="5:23" pos:end="5:23">&lt;</operator> <name pos:start="5:25" pos:end="5:39">COLLECTION_SIZE</name></expr>;</condition> <incr pos:start="5:42" pos:end="5:44"><expr pos:start="5:42" pos:end="5:44"><operator pos:start="5:42" pos:end="5:43">++</operator><name pos:start="5:44" pos:end="5:44">i</name></expr></incr>)</control> <block pos:start="5:47" pos:end="7:5">{<block_content pos:start="5:48" pos:end="7:4">
        <expr_stmt pos:start="6:9" pos:end="6:26"><expr pos:start="6:9" pos:end="6:25"><name pos:start="6:9" pos:end="6:17"><name pos:start="6:9" pos:end="6:14">member</name><index pos:start="6:15" pos:end="6:17">[<expr pos:start="6:16" pos:end="6:16"><name pos:start="6:16" pos:end="6:16">i</name></expr>]</index></name> <operator pos:start="6:19" pos:end="6:19">=</operator> <literal type="boolean" pos:start="6:21" pos:end="6:25">false</literal></expr>;</expr_stmt>
    </block_content>}</block></for>
</block_content>}</block></constructor>

<constructor pos:start="10:1" pos:end="12:1"><name pos:start="10:1" pos:end="10:8"><name pos:start="10:1" pos:end="10:3">Set</name><operator pos:start="10:4" pos:end="10:5">::</operator><name pos:start="10:6" pos:end="10:8">Set</name></name><parameter_list pos:start="10:9" pos:end="10:15">(<parameter pos:start="10:10" pos:end="10:14"><decl pos:start="10:10" pos:end="10:14"><type pos:start="10:10" pos:end="10:12"><name pos:start="10:10" pos:end="10:12">int</name></type> <name pos:start="10:14" pos:end="10:14">x</name></decl></parameter>)</parameter_list> <member_init_list pos:start="10:17" pos:end="10:24">: <call pos:start="10:19" pos:end="10:23"><name pos:start="10:19" pos:end="10:21">Set</name><argument_list pos:start="10:22" pos:end="10:23">()</argument_list></call> </member_init_list><block pos:start="10:25" pos:end="12:1">{<block_content pos:start="10:26" pos:end="12:0">
    <expr_stmt pos:start="11:5" pos:end="11:21"><expr pos:start="11:5" pos:end="11:20"><name pos:start="11:5" pos:end="11:13"><name pos:start="11:5" pos:end="11:10">member</name><index pos:start="11:11" pos:end="11:13">[<expr pos:start="11:12" pos:end="11:12"><name pos:start="11:12" pos:end="11:12">x</name></expr>]</index></name> <operator pos:start="11:15" pos:end="11:15">=</operator> <literal type="boolean" pos:start="11:17" pos:end="11:20">true</literal></expr>;</expr_stmt>
</block_content>}</block></constructor>

<function pos:start="14:1" pos:end="22:1"><type pos:start="14:1" pos:end="14:12"><name pos:start="14:1" pos:end="14:8">unsigned</name> <name pos:start="14:10" pos:end="14:12">int</name></type> <name pos:start="14:14" pos:end="14:29"><name pos:start="14:14" pos:end="14:16">Set</name><operator pos:start="14:17" pos:end="14:18">::</operator><name pos:start="14:19" pos:end="14:29">cardinality</name></name><parameter_list pos:start="14:30" pos:end="14:31">()</parameter_list> <specifier pos:start="14:33" pos:end="14:37">const</specifier> <block pos:start="14:39" pos:end="22:1">{<block_content pos:start="14:40" pos:end="22:0">
    <decl_stmt pos:start="15:5" pos:end="15:26"><decl pos:start="15:5" pos:end="15:25"><type pos:start="15:5" pos:end="15:16"><name pos:start="15:5" pos:end="15:12">unsigned</name> <name pos:start="15:14" pos:end="15:16">int</name></type> <name pos:start="15:18" pos:end="15:21">card</name> <init pos:start="15:23" pos:end="15:25">= <expr pos:start="15:25" pos:end="15:25"><literal type="number" pos:start="15:25" pos:end="15:25">0</literal></expr></init></decl>;</decl_stmt>
    <for pos:start="16:5" pos:end="20:5">for<control pos:start="16:8" pos:end="16:47">(<init pos:start="16:9" pos:end="16:21"><decl pos:start="16:9" pos:end="16:20"><type pos:start="16:9" pos:end="16:14"><name pos:start="16:9" pos:end="16:14">size_t</name></type> <name pos:start="16:16" pos:end="16:16">i</name> <init pos:start="16:18" pos:end="16:20">= <expr pos:start="16:20" pos:end="16:20"><literal type="number" pos:start="16:20" pos:end="16:20">0</literal></expr></init></decl>;</init> <condition pos:start="16:23" pos:end="16:42"><expr pos:start="16:23" pos:end="16:41"><name pos:start="16:23" pos:end="16:23">i</name> <operator pos:start="16:25" pos:end="16:25">&lt;</operator> <name pos:start="16:27" pos:end="16:41">COLLECTION_SIZE</name></expr>;</condition> <incr pos:start="16:44" pos:end="16:46"><expr pos:start="16:44" pos:end="16:46"><operator pos:start="16:44" pos:end="16:45">++</operator><name pos:start="16:46" pos:end="16:46">i</name></expr></incr>)</control> <block pos:start="16:49" pos:end="20:5">{<block_content pos:start="16:50" pos:end="20:4">
        <if_stmt pos:start="17:9" pos:end="19:9"><if pos:start="17:9" pos:end="19:9">if<condition pos:start="17:11" pos:end="17:21">(<expr pos:start="17:12" pos:end="17:20"><name pos:start="17:12" pos:end="17:20"><name pos:start="17:12" pos:end="17:17">member</name><index pos:start="17:18" pos:end="17:20">[<expr pos:start="17:19" pos:end="17:19"><name pos:start="17:19" pos:end="17:19">i</name></expr>]</index></name></expr>)</condition> <block pos:start="17:23" pos:end="19:9">{<block_content pos:start="17:24" pos:end="19:8">
            <expr_stmt pos:start="18:13" pos:end="18:19"><expr pos:start="18:13" pos:end="18:18"><operator pos:start="18:13" pos:end="18:14">++</operator><name pos:start="18:15" pos:end="18:18">card</name></expr>;</expr_stmt>
        </block_content>}</block></if></if_stmt>
    </block_content>}</block></for>
    <return pos:start="21:5" pos:end="21:16">return <expr pos:start="21:12" pos:end="21:15"><name pos:start="21:12" pos:end="21:15">card</name></expr>;</return>
</block_content>}</block></function>

<function type="operator" pos:start="24:1" pos:end="30:1"><type pos:start="24:1" pos:end="24:3"><name pos:start="24:1" pos:end="24:3">Set</name></type> <name pos:start="24:5" pos:end="24:18"><name pos:start="24:5" pos:end="24:7">Set</name><operator pos:start="24:8" pos:end="24:9">::</operator><name pos:start="24:10" pos:end="24:18">operator<name pos:start="24:18" pos:end="24:18">+</name></name></name><parameter_list pos:start="24:19" pos:end="24:34">(<parameter pos:start="24:20" pos:end="24:33"><decl pos:start="24:20" pos:end="24:33"><type pos:start="24:20" pos:end="24:29"><specifier pos:start="24:20" pos:end="24:24">const</specifier> <name pos:start="24:26" pos:end="24:28">Set</name><modifier pos:start="24:29" pos:end="24:29">&amp;</modifier></type> <name pos:start="24:31" pos:end="24:33">rhs</name></decl></parameter>)</parameter_list> <specifier pos:start="24:36" pos:end="24:40">const</specifier> <block pos:start="24:42" pos:end="30:1">{<block_content pos:start="24:43" pos:end="30:0">
    <decl_stmt pos:start="25:5" pos:end="25:15"><decl pos:start="25:5" pos:end="25:14"><type pos:start="25:5" pos:end="25:7"><name pos:start="25:5" pos:end="25:7">Set</name></type> <name pos:start="25:9" pos:end="25:14">result</name></decl>;</decl_stmt>
    <for pos:start="26:5" pos:end="28:5">for<control pos:start="26:8" pos:end="26:47">(<init pos:start="26:9" pos:end="26:21"><decl pos:start="26:9" pos:end="26:20"><type pos:start="26:9" pos:end="26:14"><name pos:start="26:9" pos:end="26:14">size_t</name></type> <name pos:start="26:16" pos:end="26:16">i</name> <init pos:start="26:18" pos:end="26:20">= <expr pos:start="26:20" pos:end="26:20"><literal type="number" pos:start="26:20" pos:end="26:20">0</literal></expr></init></decl>;</init> <condition pos:start="26:23" pos:end="26:42"><expr pos:start="26:23" pos:end="26:41"><name pos:start="26:23" pos:end="26:23">i</name> <operator pos:start="26:25" pos:end="26:25">&lt;</operator> <name pos:start="26:27" pos:end="26:41">COLLECTION_SIZE</name></expr>;</condition> <incr pos:start="26:44" pos:end="26:46"><expr pos:start="26:44" pos:end="26:46"><operator pos:start="26:44" pos:end="26:45">++</operator><name pos:start="26:46" pos:end="26:46">i</name></expr></incr>)</control> <block pos:start="26:49" pos:end="28:5">{<block_content pos:start="26:50" pos:end="28:4">
        <expr_stmt pos:start="27:9" pos:end="27:54"><expr pos:start="27:9" pos:end="27:53"><name pos:start="27:9" pos:end="27:24"><name pos:start="27:9" pos:end="27:14">result</name><operator pos:start="27:15" pos:end="27:15">.</operator><name pos:start="27:16" pos:end="27:21">member</name><index pos:start="27:22" pos:end="27:24">[<expr pos:start="27:23" pos:end="27:23"><name pos:start="27:23" pos:end="27:23">i</name></expr>]</index></name> <operator pos:start="27:26" pos:end="27:26">=</operator> <name pos:start="27:28" pos:end="27:36"><name pos:start="27:28" pos:end="27:33">member</name><index pos:start="27:34" pos:end="27:36">[<expr pos:start="27:35" pos:end="27:35"><name pos:start="27:35" pos:end="27:35">i</name></expr>]</index></name> <operator pos:start="27:38" pos:end="27:39">||</operator> <name pos:start="27:41" pos:end="27:53"><name pos:start="27:41" pos:end="27:43">rhs</name><operator pos:start="27:44" pos:end="27:44">.</operator><name pos:start="27:45" pos:end="27:50">member</name><index pos:start="27:51" pos:end="27:53">[<expr pos:start="27:52" pos:end="27:52"><name pos:start="27:52" pos:end="27:52">i</name></expr>]</index></name></expr>;</expr_stmt>
    </block_content>}</block></for>
    <return pos:start="29:5" pos:end="29:18">return <expr pos:start="29:12" pos:end="29:17"><name pos:start="29:12" pos:end="29:17">result</name></expr>;</return>
</block_content>}</block></function>

<function type="operator" pos:start="32:1" pos:end="38:1"><type pos:start="32:1" pos:end="32:3"><name pos:start="32:1" pos:end="32:3">Set</name></type> <name pos:start="32:5" pos:end="32:18"><name pos:start="32:5" pos:end="32:7">Set</name><operator pos:start="32:8" pos:end="32:9">::</operator><name pos:start="32:10" pos:end="32:18">operator<name pos:start="32:18" pos:end="32:18">*</name></name></name><parameter_list pos:start="32:19" pos:end="32:34">(<parameter pos:start="32:20" pos:end="32:33"><decl pos:start="32:20" pos:end="32:33"><type pos:start="32:20" pos:end="32:29"><specifier pos:start="32:20" pos:end="32:24">const</specifier> <name pos:start="32:26" pos:end="32:28">Set</name><modifier pos:start="32:29" pos:end="32:29">&amp;</modifier></type> <name pos:start="32:31" pos:end="32:33">rhs</name></decl></parameter>)</parameter_list> <specifier pos:start="32:36" pos:end="32:40">const</specifier> <block pos:start="32:42" pos:end="38:1">{<block_content pos:start="32:43" pos:end="38:0">
    <decl_stmt pos:start="33:5" pos:end="33:15"><decl pos:start="33:5" pos:end="33:14"><type pos:start="33:5" pos:end="33:7"><name pos:start="33:5" pos:end="33:7">Set</name></type> <name pos:start="33:9" pos:end="33:14">result</name></decl>;</decl_stmt>
    <for pos:start="34:5" pos:end="36:5">for<control pos:start="34:8" pos:end="34:47">(<init pos:start="34:9" pos:end="34:21"><decl pos:start="34:9" pos:end="34:20"><type pos:start="34:9" pos:end="34:14"><name pos:start="34:9" pos:end="34:14">size_t</name></type> <name pos:start="34:16" pos:end="34:16">i</name> <init pos:start="34:18" pos:end="34:20">= <expr pos:start="34:20" pos:end="34:20"><literal type="number" pos:start="34:20" pos:end="34:20">0</literal></expr></init></decl>;</init> <condition pos:start="34:23" pos:end="34:42"><expr pos:start="34:23" pos:end="34:41"><name pos:start="34:23" pos:end="34:23">i</name> <operator pos:start="34:25" pos:end="34:25">&lt;</operator> <name pos:start="34:27" pos:end="34:41">COLLECTION_SIZE</name></expr>;</condition> <incr pos:start="34:44" pos:end="34:46"><expr pos:start="34:44" pos:end="34:46"><operator pos:start="34:44" pos:end="34:45">++</operator><name pos:start="34:46" pos:end="34:46">i</name></expr></incr>)</control> <block pos:start="34:49" pos:end="36:5">{<block_content pos:start="34:50" pos:end="36:4">
        <expr_stmt pos:start="35:9" pos:end="35:54"><expr pos:start="35:9" pos:end="35:53"><name pos:start="35:9" pos:end="35:24"><name pos:start="35:9" pos:end="35:14">result</name><operator pos:start="35:15" pos:end="35:15">.</operator><name pos:start="35:16" pos:end="35:21">member</name><index pos:start="35:22" pos:end="35:24">[<expr pos:start="35:23" pos:end="35:23"><name pos:start="35:23" pos:end="35:23">i</name></expr>]</index></name> <operator pos:start="35:26" pos:end="35:26">=</operator> <name pos:start="35:28" pos:end="35:36"><name pos:start="35:28" pos:end="35:33">member</name><index pos:start="35:34" pos:end="35:36">[<expr pos:start="35:35" pos:end="35:35"><name pos:start="35:35" pos:end="35:35">i</name></expr>]</index></name> <operator pos:start="35:38" pos:end="35:39">&amp;&amp;</operator> <name pos:start="35:41" pos:end="35:53"><name pos:start="35:41" pos:end="35:43">rhs</name><operator pos:start="35:44" pos:end="35:44">.</operator><name pos:start="35:45" pos:end="35:50">member</name><index pos:start="35:51" pos:end="35:53">[<expr pos:start="35:52" pos:end="35:52"><name pos:start="35:52" pos:end="35:52">i</name></expr>]</index></name></expr>;</expr_stmt>
    </block_content>}</block></for>
    <return pos:start="37:5" pos:end="37:18">return <expr pos:start="37:12" pos:end="37:17"><name pos:start="37:12" pos:end="37:17">result</name></expr>;</return>
</block_content>}</block></function>

<function type="operator" pos:start="40:1" pos:end="46:1"><type pos:start="40:1" pos:end="40:3"><name pos:start="40:1" pos:end="40:3">Set</name></type> <name pos:start="40:5" pos:end="40:18"><name pos:start="40:5" pos:end="40:7">Set</name><operator pos:start="40:8" pos:end="40:9">::</operator><name pos:start="40:10" pos:end="40:18">operator<name pos:start="40:18" pos:end="40:18">-</name></name></name><parameter_list pos:start="40:19" pos:end="40:34">(<parameter pos:start="40:20" pos:end="40:33"><decl pos:start="40:20" pos:end="40:33"><type pos:start="40:20" pos:end="40:29"><specifier pos:start="40:20" pos:end="40:24">const</specifier> <name pos:start="40:26" pos:end="40:28">Set</name><modifier pos:start="40:29" pos:end="40:29">&amp;</modifier></type> <name pos:start="40:31" pos:end="40:33">rhs</name></decl></parameter>)</parameter_list> <specifier pos:start="40:36" pos:end="40:40">const</specifier> <block pos:start="40:42" pos:end="46:1">{<block_content pos:start="40:43" pos:end="46:0">
    <decl_stmt pos:start="41:5" pos:end="41:15"><decl pos:start="41:5" pos:end="41:14"><type pos:start="41:5" pos:end="41:7"><name pos:start="41:5" pos:end="41:7">Set</name></type> <name pos:start="41:9" pos:end="41:14">result</name></decl>;</decl_stmt>
    <for pos:start="42:5" pos:end="44:5">for<control pos:start="42:8" pos:end="42:47">(<init pos:start="42:9" pos:end="42:21"><decl pos:start="42:9" pos:end="42:20"><type pos:start="42:9" pos:end="42:14"><name pos:start="42:9" pos:end="42:14">size_t</name></type> <name pos:start="42:16" pos:end="42:16">i</name> <init pos:start="42:18" pos:end="42:20">= <expr pos:start="42:20" pos:end="42:20"><literal type="number" pos:start="42:20" pos:end="42:20">0</literal></expr></init></decl>;</init> <condition pos:start="42:23" pos:end="42:42"><expr pos:start="42:23" pos:end="42:41"><name pos:start="42:23" pos:end="42:23">i</name> <operator pos:start="42:25" pos:end="42:25">&lt;</operator> <name pos:start="42:27" pos:end="42:41">COLLECTION_SIZE</name></expr>;</condition> <incr pos:start="42:44" pos:end="42:46"><expr pos:start="42:44" pos:end="42:46"><operator pos:start="42:44" pos:end="42:45">++</operator><name pos:start="42:46" pos:end="42:46">i</name></expr></incr>)</control> <block pos:start="42:49" pos:end="44:5">{<block_content pos:start="42:50" pos:end="44:4">
        <expr_stmt pos:start="43:9" pos:end="43:55"><expr pos:start="43:9" pos:end="43:54"><name pos:start="43:9" pos:end="43:24"><name pos:start="43:9" pos:end="43:14">result</name><operator pos:start="43:15" pos:end="43:15">.</operator><name pos:start="43:16" pos:end="43:21">member</name><index pos:start="43:22" pos:end="43:24">[<expr pos:start="43:23" pos:end="43:23"><name pos:start="43:23" pos:end="43:23">i</name></expr>]</index></name> <operator pos:start="43:26" pos:end="43:26">=</operator> <name pos:start="43:28" pos:end="43:36"><name pos:start="43:28" pos:end="43:33">member</name><index pos:start="43:34" pos:end="43:36">[<expr pos:start="43:35" pos:end="43:35"><name pos:start="43:35" pos:end="43:35">i</name></expr>]</index></name> <operator pos:start="43:38" pos:end="43:39">&amp;&amp;</operator> <operator pos:start="43:41" pos:end="43:41">!</operator><name pos:start="43:42" pos:end="43:54"><name pos:start="43:42" pos:end="43:44">rhs</name><operator pos:start="43:45" pos:end="43:45">.</operator><name pos:start="43:46" pos:end="43:51">member</name><index pos:start="43:52" pos:end="43:54">[<expr pos:start="43:53" pos:end="43:53"><name pos:start="43:53" pos:end="43:53">i</name></expr>]</index></name></expr>;</expr_stmt>
    </block_content>}</block></for>
    <return pos:start="45:5" pos:end="45:18">return <expr pos:start="45:12" pos:end="45:17"><name pos:start="45:12" pos:end="45:17">result</name></expr>;</return>
</block_content>}</block></function>

<function type="operator" pos:start="48:1" pos:end="54:1"><type pos:start="48:1" pos:end="48:3"><name pos:start="48:1" pos:end="48:3">Set</name></type> <name pos:start="48:5" pos:end="48:18"><name pos:start="48:5" pos:end="48:7">Set</name><operator pos:start="48:8" pos:end="48:9">::</operator><name pos:start="48:10" pos:end="48:18">operator<name pos:start="48:18" pos:end="48:18">~</name></name></name><parameter_list pos:start="48:19" pos:end="48:20">()</parameter_list> <specifier pos:start="48:22" pos:end="48:26">const</specifier> <block pos:start="48:28" pos:end="54:1">{<block_content pos:start="48:29" pos:end="54:0">
    <decl_stmt pos:start="49:5" pos:end="49:15"><decl pos:start="49:5" pos:end="49:14"><type pos:start="49:5" pos:end="49:7"><name pos:start="49:5" pos:end="49:7">Set</name></type> <name pos:start="49:9" pos:end="49:14">result</name></decl>;</decl_stmt>
    <for pos:start="50:5" pos:end="52:5">for<control pos:start="50:8" pos:end="50:47">(<init pos:start="50:9" pos:end="50:21"><decl pos:start="50:9" pos:end="50:20"><type pos:start="50:9" pos:end="50:14"><name pos:start="50:9" pos:end="50:14">size_t</name></type> <name pos:start="50:16" pos:end="50:16">i</name> <init pos:start="50:18" pos:end="50:20">= <expr pos:start="50:20" pos:end="50:20"><literal type="number" pos:start="50:20" pos:end="50:20">0</literal></expr></init></decl>;</init> <condition pos:start="50:23" pos:end="50:42"><expr pos:start="50:23" pos:end="50:41"><name pos:start="50:23" pos:end="50:23">i</name> <operator pos:start="50:25" pos:end="50:25">&lt;</operator> <name pos:start="50:27" pos:end="50:41">COLLECTION_SIZE</name></expr>;</condition> <incr pos:start="50:44" pos:end="50:46"><expr pos:start="50:44" pos:end="50:46"><operator pos:start="50:44" pos:end="50:45">++</operator><name pos:start="50:46" pos:end="50:46">i</name></expr></incr>)</control> <block pos:start="50:49" pos:end="52:5">{<block_content pos:start="50:50" pos:end="52:4">
        <expr_stmt pos:start="51:9" pos:end="51:38"><expr pos:start="51:9" pos:end="51:37"><name pos:start="51:9" pos:end="51:24"><name pos:start="51:9" pos:end="51:14">result</name><operator pos:start="51:15" pos:end="51:15">.</operator><name pos:start="51:16" pos:end="51:21">member</name><index pos:start="51:22" pos:end="51:24">[<expr pos:start="51:23" pos:end="51:23"><name pos:start="51:23" pos:end="51:23">i</name></expr>]</index></name> <operator pos:start="51:26" pos:end="51:26">=</operator> <operator pos:start="51:28" pos:end="51:28">!</operator><name pos:start="51:29" pos:end="51:37"><name pos:start="51:29" pos:end="51:34">member</name><index pos:start="51:35" pos:end="51:37">[<expr pos:start="51:36" pos:end="51:36"><name pos:start="51:36" pos:end="51:36">i</name></expr>]</index></name></expr>;</expr_stmt>
    </block_content>}</block></for>
    <return pos:start="53:5" pos:end="53:18">return <expr pos:start="53:12" pos:end="53:17"><name pos:start="53:12" pos:end="53:17">result</name></expr>;</return>
</block_content>}</block></function>

<function type="operator" pos:start="56:1" pos:end="63:1"><type pos:start="56:1" pos:end="56:4"><name pos:start="56:1" pos:end="56:4">bool</name></type> <name pos:start="56:6" pos:end="56:20"><name pos:start="56:6" pos:end="56:8">Set</name><operator pos:start="56:9" pos:end="56:10">::</operator><name pos:start="56:11" pos:end="56:20">operator<name pos:start="56:19" pos:end="56:20">==</name></name></name><parameter_list pos:start="56:21" pos:end="56:36">(<parameter pos:start="56:22" pos:end="56:35"><decl pos:start="56:22" pos:end="56:35"><type pos:start="56:22" pos:end="56:31"><specifier pos:start="56:22" pos:end="56:26">const</specifier> <name pos:start="56:28" pos:end="56:30">Set</name><modifier pos:start="56:31" pos:end="56:31">&amp;</modifier></type> <name pos:start="56:33" pos:end="56:35">rhs</name></decl></parameter>)</parameter_list> <specifier pos:start="56:38" pos:end="56:42">const</specifier> <block pos:start="56:44" pos:end="63:1">{<block_content pos:start="56:45" pos:end="63:0">
    <for pos:start="57:5" pos:end="61:5">for<control pos:start="57:8" pos:end="57:47">(<init pos:start="57:9" pos:end="57:21"><decl pos:start="57:9" pos:end="57:20"><type pos:start="57:9" pos:end="57:14"><name pos:start="57:9" pos:end="57:14">size_t</name></type> <name pos:start="57:16" pos:end="57:16">i</name> <init pos:start="57:18" pos:end="57:20">= <expr pos:start="57:20" pos:end="57:20"><literal type="number" pos:start="57:20" pos:end="57:20">0</literal></expr></init></decl>;</init> <condition pos:start="57:23" pos:end="57:42"><expr pos:start="57:23" pos:end="57:41"><name pos:start="57:23" pos:end="57:23">i</name> <operator pos:start="57:25" pos:end="57:25">&lt;</operator> <name pos:start="57:27" pos:end="57:41">COLLECTION_SIZE</name></expr>;</condition> <incr pos:start="57:44" pos:end="57:46"><expr pos:start="57:44" pos:end="57:46"><operator pos:start="57:44" pos:end="57:45">++</operator><name pos:start="57:46" pos:end="57:46">i</name></expr></incr>)</control> <block pos:start="57:49" pos:end="61:5">{<block_content pos:start="57:50" pos:end="61:4">
        <if_stmt pos:start="58:9" pos:end="60:9"><if pos:start="58:9" pos:end="60:9">if<condition pos:start="58:11" pos:end="58:38">(<expr pos:start="58:12" pos:end="58:37"><name pos:start="58:12" pos:end="58:20"><name pos:start="58:12" pos:end="58:17">member</name><index pos:start="58:18" pos:end="58:20">[<expr pos:start="58:19" pos:end="58:19"><name pos:start="58:19" pos:end="58:19">i</name></expr>]</index></name> <operator pos:start="58:22" pos:end="58:23">!=</operator> <name pos:start="58:25" pos:end="58:37"><name pos:start="58:25" pos:end="58:27">rhs</name><operator pos:start="58:28" pos:end="58:28">.</operator><name pos:start="58:29" pos:end="58:34">member</name><index pos:start="58:35" pos:end="58:37">[<expr pos:start="58:36" pos:end="58:36"><name pos:start="58:36" pos:end="58:36">i</name></expr>]</index></name></expr>)</condition> <block pos:start="58:40" pos:end="60:9">{<block_content pos:start="58:41" pos:end="60:8">
            <return pos:start="59:13" pos:end="59:25">return <expr pos:start="59:20" pos:end="59:24"><literal type="boolean" pos:start="59:20" pos:end="59:24">false</literal></expr>;</return>
        </block_content>}</block></if></if_stmt>
    </block_content>}</block></for>
    <return pos:start="62:5" pos:end="62:16">return <expr pos:start="62:12" pos:end="62:15"><literal type="boolean" pos:start="62:12" pos:end="62:15">true</literal></expr>;</return>
</block_content>}</block></function>

<function type="operator" pos:start="65:1" pos:end="72:1"><type pos:start="65:1" pos:end="65:4"><name pos:start="65:1" pos:end="65:4">bool</name></type> <name pos:start="65:6" pos:end="65:20"><name pos:start="65:6" pos:end="65:8">Set</name><operator pos:start="65:9" pos:end="65:10">::</operator><name pos:start="65:11" pos:end="65:20">operator<name pos:start="65:19" pos:end="65:20">&lt;=</name></name></name><parameter_list pos:start="65:21" pos:end="65:36">(<parameter pos:start="65:22" pos:end="65:35"><decl pos:start="65:22" pos:end="65:35"><type pos:start="65:22" pos:end="65:31"><specifier pos:start="65:22" pos:end="65:26">const</specifier> <name pos:start="65:28" pos:end="65:30">Set</name><modifier pos:start="65:31" pos:end="65:31">&amp;</modifier></type> <name pos:start="65:33" pos:end="65:35">rhs</name></decl></parameter>)</parameter_list> <specifier pos:start="65:38" pos:end="65:42">const</specifier> <block pos:start="65:44" pos:end="72:1">{<block_content pos:start="65:45" pos:end="72:0">
    <for pos:start="66:5" pos:end="70:5">for<control pos:start="66:8" pos:end="66:47">(<init pos:start="66:9" pos:end="66:21"><decl pos:start="66:9" pos:end="66:20"><type pos:start="66:9" pos:end="66:14"><name pos:start="66:9" pos:end="66:14">size_t</name></type> <name pos:start="66:16" pos:end="66:16">i</name> <init pos:start="66:18" pos:end="66:20">= <expr pos:start="66:20" pos:end="66:20"><literal type="number" pos:start="66:20" pos:end="66:20">0</literal></expr></init></decl>;</init> <condition pos:start="66:23" pos:end="66:42"><expr pos:start="66:23" pos:end="66:41"><name pos:start="66:23" pos:end="66:23">i</name> <operator pos:start="66:25" pos:end="66:25">&lt;</operator> <name pos:start="66:27" pos:end="66:41">COLLECTION_SIZE</name></expr>;</condition> <incr pos:start="66:44" pos:end="66:46"><expr pos:start="66:44" pos:end="66:46"><operator pos:start="66:44" pos:end="66:45">++</operator><name pos:start="66:46" pos:end="66:46">i</name></expr></incr>)</control> <block pos:start="66:49" pos:end="70:5">{<block_content pos:start="66:50" pos:end="70:4">
        <if_stmt pos:start="67:9" pos:end="69:9"><if pos:start="67:9" pos:end="69:9">if<condition pos:start="67:11" pos:end="67:39">(<expr pos:start="67:12" pos:end="67:38"><name pos:start="67:12" pos:end="67:20"><name pos:start="67:12" pos:end="67:17">member</name><index pos:start="67:18" pos:end="67:20">[<expr pos:start="67:19" pos:end="67:19"><name pos:start="67:19" pos:end="67:19">i</name></expr>]</index></name> <operator pos:start="67:22" pos:end="67:23">&amp;&amp;</operator> <operator pos:start="67:25" pos:end="67:25">!</operator><name pos:start="67:26" pos:end="67:38"><name pos:start="67:26" pos:end="67:28">rhs</name><operator pos:start="67:29" pos:end="67:29">.</operator><name pos:start="67:30" pos:end="67:35">member</name><index pos:start="67:36" pos:end="67:38">[<expr pos:start="67:37" pos:end="67:37"><name pos:start="67:37" pos:end="67:37">i</name></expr>]</index></name></expr>)</condition> <block pos:start="67:41" pos:end="69:9">{<block_content pos:start="67:42" pos:end="69:8">
            <return pos:start="68:13" pos:end="68:25">return <expr pos:start="68:20" pos:end="68:24"><literal type="boolean" pos:start="68:20" pos:end="68:24">false</literal></expr>;</return>
        </block_content>}</block></if></if_stmt>
    </block_content>}</block></for>
    <return pos:start="71:5" pos:end="71:16">return <expr pos:start="71:12" pos:end="71:15"><literal type="boolean" pos:start="71:12" pos:end="71:15">true</literal></expr>;</return>
</block_content>}</block></function>

<function type="operator" pos:start="74:1" pos:end="83:1"><type pos:start="74:1" pos:end="74:13"><name pos:start="74:1" pos:end="74:12"><name pos:start="74:1" pos:end="74:3">std</name><operator pos:start="74:4" pos:end="74:5">::</operator><name pos:start="74:6" pos:end="74:12">ostream</name></name><modifier pos:start="74:13" pos:end="74:13">&amp;</modifier></type> <name pos:start="74:15" pos:end="74:24">operator<name pos:start="74:23" pos:end="74:24">&lt;&lt;</name></name><parameter_list pos:start="74:25" pos:end="74:59">(<parameter pos:start="74:26" pos:end="74:42"><decl pos:start="74:26" pos:end="74:42"><type pos:start="74:26" pos:end="74:38"><name pos:start="74:26" pos:end="74:37"><name pos:start="74:26" pos:end="74:28">std</name><operator pos:start="74:29" pos:end="74:30">::</operator><name pos:start="74:31" pos:end="74:37">ostream</name></name><modifier pos:start="74:38" pos:end="74:38">&amp;</modifier></type> <name pos:start="74:40" pos:end="74:42">out</name></decl></parameter>, <parameter pos:start="74:45" pos:end="74:58"><decl pos:start="74:45" pos:end="74:58"><type pos:start="74:45" pos:end="74:54"><specifier pos:start="74:45" pos:end="74:49">const</specifier> <name pos:start="74:51" pos:end="74:53">Set</name><modifier pos:start="74:54" pos:end="74:54">&amp;</modifier></type> <name pos:start="74:56" pos:end="74:58">rhs</name></decl></parameter>)</parameter_list> <block pos:start="74:61" pos:end="83:1">{<block_content pos:start="74:62" pos:end="83:0">
    <expr_stmt pos:start="75:5" pos:end="75:19"><expr pos:start="75:5" pos:end="75:18"><name pos:start="75:5" pos:end="75:7">out</name> <operator pos:start="75:9" pos:end="75:10">&lt;&lt;</operator> <literal type="string" pos:start="75:12" pos:end="75:18">"set( "</literal></expr>;</expr_stmt>
    <for pos:start="76:5" pos:end="80:5">for<control pos:start="76:8" pos:end="76:47">(<init pos:start="76:9" pos:end="76:21"><decl pos:start="76:9" pos:end="76:20"><type pos:start="76:9" pos:end="76:14"><name pos:start="76:9" pos:end="76:14">size_t</name></type> <name pos:start="76:16" pos:end="76:16">i</name> <init pos:start="76:18" pos:end="76:20">= <expr pos:start="76:20" pos:end="76:20"><literal type="number" pos:start="76:20" pos:end="76:20">0</literal></expr></init></decl>;</init> <condition pos:start="76:23" pos:end="76:42"><expr pos:start="76:23" pos:end="76:41"><name pos:start="76:23" pos:end="76:23">i</name> <operator pos:start="76:25" pos:end="76:25">&lt;</operator> <name pos:start="76:27" pos:end="76:41">COLLECTION_SIZE</name></expr>;</condition> <incr pos:start="76:44" pos:end="76:46"><expr pos:start="76:44" pos:end="76:46"><operator pos:start="76:44" pos:end="76:45">++</operator><name pos:start="76:46" pos:end="76:46">i</name></expr></incr>)</control> <block pos:start="76:49" pos:end="80:5">{<block_content pos:start="76:50" pos:end="80:4">
        <if_stmt pos:start="77:9" pos:end="79:9"><if pos:start="77:9" pos:end="79:9">if<condition pos:start="77:11" pos:end="77:25">(<expr pos:start="77:12" pos:end="77:24"><name pos:start="77:12" pos:end="77:24"><name pos:start="77:12" pos:end="77:14">rhs</name><operator pos:start="77:15" pos:end="77:15">.</operator><name pos:start="77:16" pos:end="77:21">member</name><index pos:start="77:22" pos:end="77:24">[<expr pos:start="77:23" pos:end="77:23"><name pos:start="77:23" pos:end="77:23">i</name></expr>]</index></name></expr>)</condition> <block pos:start="77:27" pos:end="79:9">{<block_content pos:start="77:28" pos:end="79:8">
            <expr_stmt pos:start="78:13" pos:end="78:28"><expr pos:start="78:13" pos:end="78:27"><name pos:start="78:13" pos:end="78:15">out</name> <operator pos:start="78:17" pos:end="78:18">&lt;&lt;</operator> <name pos:start="78:20" pos:end="78:20">i</name> <operator pos:start="78:22" pos:end="78:23">&lt;&lt;</operator> <literal type="char" pos:start="78:25" pos:end="78:27">' '</literal></expr>;</expr_stmt>
        </block_content>}</block></if></if_stmt>
    </block_content>}</block></for>
    <expr_stmt pos:start="81:5" pos:end="81:15"><expr pos:start="81:5" pos:end="81:14"><name pos:start="81:5" pos:end="81:7">out</name> <operator pos:start="81:9" pos:end="81:10">&lt;&lt;</operator> <literal type="string" pos:start="81:12" pos:end="81:14">")"</literal></expr>;</expr_stmt>
    <return pos:start="82:5" pos:end="82:15">return <expr pos:start="82:12" pos:end="82:14"><name pos:start="82:12" pos:end="82:14">out</name></expr>;</return>
</block_content>}</block></function>

<function type="operator" pos:start="85:1" pos:end="87:1"><type pos:start="85:1" pos:end="85:4"><name pos:start="85:1" pos:end="85:4">bool</name></type> <name pos:start="85:6" pos:end="85:15">operator<name pos:start="85:14" pos:end="85:15">!=</name></name><parameter_list pos:start="85:16" pos:end="85:47">(<parameter pos:start="85:17" pos:end="85:30"><decl pos:start="85:17" pos:end="85:30"><type pos:start="85:17" pos:end="85:26"><specifier pos:start="85:17" pos:end="85:21">const</specifier> <name pos:start="85:23" pos:end="85:25">Set</name><modifier pos:start="85:26" pos:end="85:26">&amp;</modifier></type> <name pos:start="85:28" pos:end="85:30">lhs</name></decl></parameter>, <parameter pos:start="85:33" pos:end="85:46"><decl pos:start="85:33" pos:end="85:46"><type pos:start="85:33" pos:end="85:42"><specifier pos:start="85:33" pos:end="85:37">const</specifier> <name pos:start="85:39" pos:end="85:41">Set</name><modifier pos:start="85:42" pos:end="85:42">&amp;</modifier></type> <name pos:start="85:44" pos:end="85:46">rhs</name></decl></parameter>)</parameter_list> <block pos:start="85:49" pos:end="87:1">{<block_content pos:start="85:50" pos:end="87:0">
    <return pos:start="86:5" pos:end="86:25">return <expr pos:start="86:12" pos:end="86:24"><operator pos:start="86:12" pos:end="86:12">!</operator><operator pos:start="86:13" pos:end="86:13">(</operator><name pos:start="86:14" pos:end="86:16">lhs</name> <operator pos:start="86:18" pos:end="86:19">==</operator> <name pos:start="86:21" pos:end="86:23">rhs</name><operator pos:start="86:24" pos:end="86:24">)</operator></expr>;</return>
</block_content>}</block></function>
<function type="operator" pos:start="88:1" pos:end="90:1"><type pos:start="88:1" pos:end="88:4"><name pos:start="88:1" pos:end="88:4">bool</name></type> <name pos:start="88:6" pos:end="88:14">operator<name pos:start="88:14" pos:end="88:14">&lt;</name></name> <parameter_list pos:start="88:16" pos:end="88:47">(<parameter pos:start="88:17" pos:end="88:30"><decl pos:start="88:17" pos:end="88:30"><type pos:start="88:17" pos:end="88:26"><specifier pos:start="88:17" pos:end="88:21">const</specifier> <name pos:start="88:23" pos:end="88:25">Set</name><modifier pos:start="88:26" pos:end="88:26">&amp;</modifier></type> <name pos:start="88:28" pos:end="88:30">lhs</name></decl></parameter>, <parameter pos:start="88:33" pos:end="88:46"><decl pos:start="88:33" pos:end="88:46"><type pos:start="88:33" pos:end="88:42"><specifier pos:start="88:33" pos:end="88:37">const</specifier> <name pos:start="88:39" pos:end="88:41">Set</name><modifier pos:start="88:42" pos:end="88:42">&amp;</modifier></type> <name pos:start="88:44" pos:end="88:46">rhs</name></decl></parameter>)</parameter_list> <block pos:start="88:49" pos:end="90:1">{<block_content pos:start="88:50" pos:end="90:0">
    <return pos:start="89:5" pos:end="89:21">return <expr pos:start="89:12" pos:end="89:20"><name pos:start="89:12" pos:end="89:14">rhs</name> <operator pos:start="89:16" pos:end="89:16">&gt;</operator> <name pos:start="89:18" pos:end="89:20">lhs</name></expr>;</return>
</block_content>}</block></function>
<function type="operator" pos:start="91:1" pos:end="93:1"><type pos:start="91:1" pos:end="91:4"><name pos:start="91:1" pos:end="91:4">bool</name></type> <name pos:start="91:6" pos:end="91:15">operator<name pos:start="91:14" pos:end="91:15">&gt;=</name></name><parameter_list pos:start="91:16" pos:end="91:47">(<parameter pos:start="91:17" pos:end="91:30"><decl pos:start="91:17" pos:end="91:30"><type pos:start="91:17" pos:end="91:26"><specifier pos:start="91:17" pos:end="91:21">const</specifier> <name pos:start="91:23" pos:end="91:25">Set</name><modifier pos:start="91:26" pos:end="91:26">&amp;</modifier></type> <name pos:start="91:28" pos:end="91:30">lhs</name></decl></parameter>, <parameter pos:start="91:33" pos:end="91:46"><decl pos:start="91:33" pos:end="91:46"><type pos:start="91:33" pos:end="91:42"><specifier pos:start="91:33" pos:end="91:37">const</specifier> <name pos:start="91:39" pos:end="91:41">Set</name><modifier pos:start="91:42" pos:end="91:42">&amp;</modifier></type> <name pos:start="91:44" pos:end="91:46">rhs</name></decl></parameter>)</parameter_list> <block pos:start="91:49" pos:end="93:1">{<block_content pos:start="91:50" pos:end="93:0">
    <return pos:start="92:5" pos:end="92:22">return <expr pos:start="92:12" pos:end="92:21"><name pos:start="92:12" pos:end="92:14">rhs</name> <operator pos:start="92:16" pos:end="92:17">&lt;=</operator> <name pos:start="92:19" pos:end="92:21">lhs</name></expr>;</return>
</block_content>}</block></function>
<function type="operator" pos:start="94:1" pos:end="96:1"><type pos:start="94:1" pos:end="94:4"><name pos:start="94:1" pos:end="94:4">bool</name></type> <name pos:start="94:6" pos:end="94:14">operator<name pos:start="94:14" pos:end="94:14">&gt;</name></name> <parameter_list pos:start="94:16" pos:end="94:47">(<parameter pos:start="94:17" pos:end="94:30"><decl pos:start="94:17" pos:end="94:30"><type pos:start="94:17" pos:end="94:26"><specifier pos:start="94:17" pos:end="94:21">const</specifier> <name pos:start="94:23" pos:end="94:25">Set</name><modifier pos:start="94:26" pos:end="94:26">&amp;</modifier></type> <name pos:start="94:28" pos:end="94:30">lhs</name></decl></parameter>, <parameter pos:start="94:33" pos:end="94:46"><decl pos:start="94:33" pos:end="94:46"><type pos:start="94:33" pos:end="94:42"><specifier pos:start="94:33" pos:end="94:37">const</specifier> <name pos:start="94:39" pos:end="94:41">Set</name><modifier pos:start="94:42" pos:end="94:42">&amp;</modifier></type> <name pos:start="94:44" pos:end="94:46">rhs</name></decl></parameter>)</parameter_list> <block pos:start="94:49" pos:end="96:1">{<block_content pos:start="94:50" pos:end="96:0">
    <return pos:start="95:5" pos:end="95:25">return <expr pos:start="95:12" pos:end="95:24"><operator pos:start="95:12" pos:end="95:12">!</operator><operator pos:start="95:13" pos:end="95:13">(</operator><name pos:start="95:14" pos:end="95:16">lhs</name> <operator pos:start="95:18" pos:end="95:19">&lt;=</operator> <name pos:start="95:21" pos:end="95:23">rhs</name><operator pos:start="95:24" pos:end="95:24">)</operator></expr>;</return>
</block_content>}</block></function>

</unit>

<unit xmlns:cpp="http://www.srcML.org/srcML/cpp" revision="1.0.0" language="C++" filename="test_set.hpp" pos:tabs="8" hash="d69ede479064a9957a2bfd1d21876fcd4caf70cb"><cpp:ifndef pos:start="1:1" pos:end="1:30">#<cpp:directive pos:start="1:2" pos:end="1:7">ifndef</cpp:directive> <name pos:start="1:9" pos:end="1:30">NAMECOLLECTOR_SET_HPP_</name></cpp:ifndef>
<cpp:define pos:start="2:1" pos:end="2:30">#<cpp:directive pos:start="2:2" pos:end="2:7">define</cpp:directive> <cpp:macro pos:start="2:9" pos:end="2:30"><name pos:start="2:9" pos:end="2:30">NAMECOLLECTOR_SET_HPP_</name></cpp:macro></cpp:define>

<cpp:include pos:start="4:1" pos:end="4:19">#<cpp:directive pos:start="4:2" pos:end="4:8">include</cpp:directive> <cpp:file pos:start="4:10" pos:end="4:19">&lt;iostream&gt;</cpp:file></cpp:include>

<decl_stmt pos:start="6:1" pos:end="6:41"><decl pos:start="6:1" pos:end="6:40"><type pos:start="6:1" pos:end="6:18"><specifier pos:start="6:1" pos:end="6:5">const</specifier> <name pos:start="6:7" pos:end="6:14">unsigned</name> <name pos:start="6:16" pos:end="6:18">int</name></type> <name pos:start="6:20" pos:end="6:34">COLLECTION_SIZE</name> <init pos:start="6:36" pos:end="6:40">= <expr pos:start="6:38" pos:end="6:40"><literal type="number" pos:start="6:38" pos:end="6:40">100</literal></expr></init></decl>;</decl_stmt>


<class pos:start="9:1" pos:end="30:2">class <name pos:start="9:7" pos:end="9:9">Set</name> <block pos:start="9:11" pos:end="30:1">{<private type="default" pos:start="9:12" pos:end="10:0">
</private><public pos:start="10:1" pos:end="28:0">public:
    <constructor_decl pos:start="11:5" pos:end="11:10"><name pos:start="11:5" pos:end="11:7">Set</name><parameter_list pos:start="11:8" pos:end="11:9">()</parameter_list>;</constructor_decl>
    <constructor_decl pos:start="12:5" pos:end="12:13"><name pos:start="12:5" pos:end="12:7">Set</name><parameter_list pos:start="12:8" pos:end="12:12">(<parameter pos:start="12:9" pos:end="12:11"><decl pos:start="12:9" pos:end="12:11"><type pos:start="12:9" pos:end="12:11"><name pos:start="12:9" pos:end="12:11">int</name></type></decl></parameter>)</parameter_list>;</constructor_decl>

    <function_decl pos:start="14:5" pos:end="14:38"><type pos:start="14:5" pos:end="14:16"><name pos:start="14:5" pos:end="14:12">unsigned</name> <name pos:start="14:14" pos:end="14:16">int</name></type> <name pos:start="14:18" pos:end="14:28">cardinality</name> <parameter_list pos:start="14:30" pos:end="14:31">()</parameter_list> <specifier pos:start="14:33" pos:end="14:37">const</specifier>;</function_decl>
    <function_decl type="operator" pos:start="15:5" pos:end="15:32"><type pos:start="15:5" pos:end="15:8"><name pos:start="15:5" pos:end="15:8">bool</name></type> <name pos:start="15:10" pos:end="15:19">operator<name pos:start="15:18" pos:end="15:19">[]</name></name> <parameter_list pos:start="15:21" pos:end="15:25">(<parameter pos:start="15:22" pos:end="15:24"><decl pos:start="15:22" pos:end="15:24"><type pos:start="15:22" pos:end="15:24"><name pos:start="15:22" pos:end="15:24">int</name></type></decl></parameter>)</parameter_list> <specifier pos:start="15:27" pos:end="15:31">const</specifier>;</function_decl>

    <function_decl type="operator" pos:start="17:5" pos:end="17:36"><type pos:start="17:5" pos:end="17:7"><name pos:start="17:5" pos:end="17:7">Set</name></type> <name pos:start="17:9" pos:end="17:17">operator<name pos:start="17:17" pos:end="17:17">+</name></name><parameter_list pos:start="17:18" pos:end="17:29">(<parameter pos:start="17:19" pos:end="17:28"><decl pos:start="17:19" pos:end="17:28"><type pos:start="17:19" pos:end="17:28"><specifier pos:start="17:19" pos:end="17:23">const</specifier> <name pos:start="17:25" pos:end="17:27">Set</name><modifier pos:start="17:28" pos:end="17:28">&amp;</modifier></type></decl></parameter>)</parameter_list> <specifier pos:start="17:31" pos:end="17:35">const</specifier>;</function_decl>
    <function_decl type="operator" pos:start="18:5" pos:end="18:36"><type pos:start="18:5" pos:end="18:7"><name pos:start="18:5" pos:end="18:7">Set</name></type> <name pos:start="18:9" pos:end="18:17">operator<name pos:start="18:17" pos:end="18:17">*</name></name><parameter_list pos:start="18:18" pos:end="18:29">(<parameter pos:start="18:19" pos:end="18:28"><decl pos:start="18:19" pos:end="18:28"><type pos:start="18:19" pos:end="18:28"><specifier pos:start="18:19" pos:end="18:23">const</specifier> <name pos:start="18:25" pos:end="18:27">Set</name><modifier pos:start="18:28" pos:end="18:28">&amp;</modifier></type></decl></parameter>)</parameter_list> <specifier pos:start="18:31" pos:end="18:35">const</specifier>;</function_decl>
    <function_decl type="operator" pos:start="19:5" pos:end="19:36"><type pos:start="19:5" pos:end="19:7"><name pos:start="19:5" pos:end="19:7">Set</name></type> <name pos:start="19:9" pos:end="19:17">operator<name pos:start="19:17" pos:end="19:17">-</name></name><parameter_list pos:start="19:18" pos:end="19:29">(<parameter pos:start="19:19" pos:end="19:28"><decl pos:start="19:19" pos:end="19:28"><type pos:start="19:19" pos:end="19:28"><specifier pos:start="19:19" pos:end="19:23">const</specifier> <name pos:start="19:25" pos:end="19:27">Set</name><modifier pos:start="19:28" pos:end="19:28">&amp;</modifier></type></decl></parameter>)</parameter_list> <specifier pos:start="19:31" pos:end="19:35">const</specifier>;</function_decl>

    <function_decl type="operator" pos:start="21:5" pos:end="21:26"><type pos:start="21:5" pos:end="21:7"><name pos:start="21:5" pos:end="21:7">Set</name></type> <name pos:start="21:9" pos:end="21:17">operator<name pos:start="21:17" pos:end="21:17">~</name></name><parameter_list pos:start="21:18" pos:end="21:19">()</parameter_list> <specifier pos:start="21:21" pos:end="21:25">const</specifier>;</function_decl>

    <function_decl type="operator" pos:start="23:5" pos:end="23:38"><type pos:start="23:5" pos:end="23:8"><name pos:start="23:5" pos:end="23:8">bool</name></type> <name pos:start="23:10" pos:end="23:19">operator<name pos:start="23:18" pos:end="23:19">==</name></name><parameter_list pos:start="23:20" pos:end="23:31">(<parameter pos:start="23:21" pos:end="23:30"><decl pos:start="23:21" pos:end="23:30"><type pos:start="23:21" pos:end="23:30"><specifier pos:start="23:21" pos:end="23:25">const</specifier> <name pos:start="23:27" pos:end="23:29">Set</name><modifier pos:start="23:30" pos:end="23:30">&amp;</modifier></type></decl></parameter>)</parameter_list> <specifier pos:start="23:33" pos:end="23:37">const</specifier>;</function_decl>
    <function_decl type="operator" pos:start="24:5" pos:end="24:38"><type pos:start="24:5" pos:end="24:8"><name pos:start="24:5" pos:end="24:8">bool</name></type> <name pos:start="24:10" pos:end="24:19">operator<name pos:start="24:18" pos:end="24:19">&lt;=</name></name><parameter_list pos:start="24:20" pos:end="24:31">(<parameter pos:start="24:21" pos:end="24:30"><decl pos:start="24:21" pos:end="24:30"><type pos:start="24:21" pos:end="24:30"><specifier pos:start="24:21" pos:end="24:25">const</specifier> <name pos:start="24:27" pos:end="24:29">Set</name><modifier pos:start="24:30" pos:end="24:30">&amp;</modifier></type></decl></parameter>)</parameter_list> <specifier pos:start="24:33" pos:end="24:37">const</specifier>;</function_decl>

    <friend pos:start="26:5" pos:end="26:63">friend <function_decl type="operator" pos:start="26:12" pos:end="26:63"><type pos:start="26:12" pos:end="26:24"><name pos:start="26:12" pos:end="26:23"><name pos:start="26:12" pos:end="26:14">std</name><operator pos:start="26:15" pos:end="26:16">::</operator><name pos:start="26:17" pos:end="26:23">ostream</name></name><modifier pos:start="26:24" pos:end="26:24">&amp;</modifier></type> <name pos:start="26:26" pos:end="26:35">operator<name pos:start="26:34" pos:end="26:35">&lt;&lt;</name></name><parameter_list pos:start="26:36" pos:end="26:62">(<parameter pos:start="26:37" pos:end="26:49"><decl pos:start="26:37" pos:end="26:49"><type pos:start="26:37" pos:end="26:49"><name pos:start="26:37" pos:end="26:48"><name pos:start="26:37" pos:end="26:39">std</name><operator pos:start="26:40" pos:end="26:41">::</operator><name pos:start="26:42" pos:end="26:48">ostream</name></name><modifier pos:start="26:49" pos:end="26:49">&amp;</modifier></type></decl></parameter>, <parameter pos:start="26:52" pos:end="26:61"><decl pos:start="26:52" pos:end="26:61"><type pos:start="26:52" pos:end="26:61"><specifier pos:start="26:52" pos:end="26:56">const</specifier> <name pos:start="26:58" pos:end="26:60">Set</name><modifier pos:start="26:61" pos:end="26:61">&amp;</modifier></type></decl></parameter>)</parameter_list>;</function_decl></friend>

</public><private pos:start="28:1" pos:end="30:0">private:
    <decl_stmt pos:start="29:5" pos:end="29:33"><decl pos:start="29:5" pos:end="29:32"><type pos:start="29:5" pos:end="29:8"><name pos:start="29:5" pos:end="29:8">bool</name></type> <name pos:start="29:10" pos:end="29:32"><name pos:start="29:10" pos:end="29:15">member</name><index pos:start="29:16" pos:end="29:32">[<expr pos:start="29:17" pos:end="29:31"><name pos:start="29:17" pos:end="29:31">COLLECTION_SIZE</name></expr>]</index></name></decl>;</decl_stmt>
</private>}</block>;</class>


<function_decl type="operator" pos:start="33:1" pos:end="33:40"><type pos:start="33:1" pos:end="33:4"><name pos:start="33:1" pos:end="33:4">bool</name></type> <name pos:start="33:6" pos:end="33:15">operator<name pos:start="33:14" pos:end="33:15">!=</name></name><parameter_list pos:start="33:16" pos:end="33:39">(<parameter pos:start="33:17" pos:end="33:26"><decl pos:start="33:17" pos:end="33:26"><type pos:start="33:17" pos:end="33:26"><specifier pos:start="33:17" pos:end="33:21">const</specifier> <name pos:start="33:23" pos:end="33:25">Set</name><modifier pos:start="33:26" pos:end="33:26">&amp;</modifier></type></decl></parameter>, <parameter pos:start="33:29" pos:end="33:38"><decl pos:start="33:29" pos:end="33:38"><type pos:start="33:29" pos:end="33:38"><specifier pos:start="33:29" pos:end="33:33">const</specifier> <name pos:start="33:35" pos:end="33:37">Set</name><modifier pos:start="33:38" pos:end="33:38">&amp;</modifier></type></decl></parameter>)</parameter_list>;</function_decl>
<function_decl type="operator" pos:start="34:1" pos:end="34:40"><type pos:start="34:1" pos:end="34:4"><name pos:start="34:1" pos:end="34:4">bool</name></type> <name pos:start="34:6" pos:end="34:14">operator<name pos:start="34:14" pos:end="34:14">&lt;</name></name> <parameter_list pos:start="34:16" pos:end="34:39">(<parameter pos:start="34:17" pos:end="34:26"><decl pos:start="34:17" pos:end="34:26"><type pos:start="34:17" pos:end="34:26"><specifier pos:start="34:17" pos:end="34:21">const</specifier> <name pos:start="34:23" pos:end="34:25">Set</name><modifier pos:start="34:26" pos:end="34:26">&amp;</modifier></type></decl></parameter>, <parameter pos:start="34:29" pos:end="34:38"><decl pos:start="34:29" pos:end="34:38"><type pos:start="34:29" pos:end="34:38"><specifier pos:start="34:29" pos:end="34:33">const</specifier> <name pos:start="34:35" pos:end="34:37">Set</name><modifier pos:start="34:38" pos:end="34:38">&amp;</modifier></type></decl></parameter>)</parameter_list>;</function_decl>
<function_decl type="operator" pos:start="35:1" pos:end="35:40"><type pos:start="35:1" pos:end="35:4"><name pos:start="35:1" pos:end="35:4">bool</name></type> <name pos:start="35:6" pos:end="35:15">operator<name pos:start="35:14" pos:end="35:15">&gt;=</name></name><parameter_list pos:start="35:16" pos:end="35:39">(<parameter pos:start="35:17" pos:end="35:26"><decl pos:start="35:17" pos:end="35:26"><type pos:start="35:17" pos:end="35:26"><specifier pos:start="35:17" pos:end="35:21">const</specifier> <name pos:start="35:23" pos:end="35:25">Set</name><modifier pos:start="35:26" pos:end="35:26">&amp;</modifier></type></decl></parameter>, <parameter pos:start="35:29" pos:end="35:38"><decl pos:start="35:29" pos:end="35:38"><type pos:start="35:29" pos:end="35:38"><specifier pos:start="35:29" pos:end="35:33">const</specifier> <name pos:start="35:35" pos:end="35:37">Set</name><modifier pos:start="35:38" pos:end="35:38">&amp;</modifier></type></decl></parameter>)</parameter_list>;</function_decl>
<function_decl type="operator" pos:start="36:1" pos:end="36:40"><type pos:start="36:1" pos:end="36:4"><name pos:start="36:1" pos:end="36:4">bool</name></type> <name pos:start="36:6" pos:end="36:14">operator<name pos:start="36:14" pos:end="36:14">&gt;</name></name> <parameter_list pos:start="36:16" pos:end="36:39">(<parameter pos:start="36:17" pos:end="36:26"><decl pos:start="36:17" pos:end="36:26"><type pos:start="36:17" pos:end="36:26"><specifier pos:start="36:17" pos:end="36:21">const</specifier> <name pos:start="36:23" pos:end="36:25">Set</name><modifier pos:start="36:26" pos:end="36:26">&amp;</modifier></type></decl></parameter>, <parameter pos:start="36:29" pos:end="36:38"><decl pos:start="36:29" pos:end="36:38"><type pos:start="36:29" pos:end="36:38"><specifier pos:start="36:29" pos:end="36:33">const</specifier> <name pos:start="36:35" pos:end="36:37">Set</name><modifier pos:start="36:38" pos:end="36:38">&amp;</modifier></type></decl></parameter>)</parameter_list>;</function_decl>



<cpp:endif pos:start="40:1" pos:end="40:6">#<cpp:directive pos:start="40:2" pos:end="40:6">endif</cpp:directive></cpp:endif>
</unit>

<unit xmlns:cpp="http://www.srcML.org/srcML/cpp" revision="1.0.0" language="C++" filename="test_set_main.cpp" pos:tabs="8" hash="e1719eaf257b2c66e5aa5267ff855c4af8d82673"><cpp:include pos:start="1:1" pos:end="1:23">#<cpp:directive pos:start="1:2" pos:end="1:8">include</cpp:directive> <cpp:file pos:start="1:10" pos:end="1:23">"test_set.hpp"</cpp:file></cpp:include>


<function pos:start="4:1" pos:end="18:1"><type pos:start="4:1" pos:end="4:3"><name pos:start="4:1" pos:end="4:3">int</name></type> <name pos:start="4:5" pos:end="4:8">main</name><parameter_list pos:start="4:9" pos:end="4:10">()</parameter_list> <block pos:start="4:12" pos:end="18:1">{<block_content pos:start="4:13" pos:end="18:0">
    <decl_stmt pos:start="5:5" pos:end="5:10"><decl pos:start="5:5" pos:end="5:9"><type pos:start="5:5" pos:end="5:7"><name pos:start="5:5" pos:end="5:7">Set</name></type> <name pos:start="5:9" pos:end="5:9">x</name></decl>;</decl_stmt>
    <decl_stmt pos:start="6:5" pos:end="6:14"><decl pos:start="6:5" pos:end="6:13"><type pos:start="6:5" pos:end="6:7"><name pos:start="6:5" pos:end="6:7">Set</name></type> <name pos:start="6:9" pos:end="6:9">y</name><argument_list pos:start="6:10" pos:end="6:13">(<argument pos:start="6:11" pos:end="6:12"><expr pos:start="6:11" pos:end="6:12"><literal type="number" pos:start="6:11" pos:end="6:12">10</literal></expr></argument>)</argument_list></decl>;</decl_stmt>
    <expr_stmt pos:start="7:5" pos:end="7:32"><expr pos:start="7:5" pos:end="7:31"><name pos:start="7:5" pos:end="7:13"><name pos:start="7:5" pos:end="7:7">std</name><operator pos:start="7:8" pos:end="7:9">::</operator><name pos:start="7:10" pos:end="7:13">cout</name></name> <operator pos:start="7:15" pos:end="7:16">&lt;&lt;</operator> <name pos:start="7:18" pos:end="7:18">x</name> <operator pos:start="7:20" pos:end="7:21">&lt;&lt;</operator> <name pos:start="7:23" pos:end="7:31"><name pos:start="7:23" pos:end="7:25">std</name><operator pos:start="7:26" pos:end="7:27">::</operator><name pos:start="7:28" pos:end="7:31">endl</name></name></expr>;</expr_stmt>
    <expr_stmt pos:start="8:5" pos:end="8:33"><expr pos:start="8:5" pos:end="8:32"><name pos:start="8:5" pos:end="8:13"><name pos:start="8:5" pos:end="8:7">std</name><operator pos:start="8:8" pos:end="8:9">::</operator><name pos:start="8:10" pos:end="8:13">cout</name></name> <operator pos:start="8:15" pos:end="8:16">&lt;&lt;</operator> <operator pos:start="8:18" pos:end="8:18">~</operator><name pos:start="8:19" pos:end="8:19">x</name> <operator pos:start="8:21" pos:end="8:22">&lt;&lt;</operator> <name pos:start="8:24" pos:end="8:32"><name pos:start="8:24" pos:end="8:26">std</name><operator pos:start="8:27" pos:end="8:28">::</operator><name pos:start="8:29" pos:end="8:32">endl</name></name></expr>;</expr_stmt>
    <expr_stmt pos:start="9:5" pos:end="9:32"><expr pos:start="9:5" pos:end="9:31"><name pos:start="9:5" pos:end="9:13"><name pos:start="9:5" pos:end="9:7">std</name><operator pos:start="9:8" pos:end="9:9">::</operator><name pos:start="9:10" pos:end="9:13">cout</name></name> <operator pos:start="9:15" pos:end="9:16">&lt;&lt;</operator> <name pos:start="9:18" pos:end="9:18">y</name> <operator pos:start="9:20" pos:end="9:21">&lt;&lt;</operator> <name pos:start="9:23" pos:end="9:31"><name pos:start="9:23" pos:end="9:25">std</name><operator pos:start="9:26" pos:end="9:27">::</operator><name pos:start="9:28" pos:end="9:31">endl</name></name></expr>;</expr_stmt>
    <expr_stmt pos:start="10:5" pos:end="10:33"><expr pos:start="10:5" pos:end="10:32"><name pos:start="10:5" pos:end="10:13"><name pos:start="10:5" pos:end="10:7">std</name><operator pos:start="10:8" pos:end="10:9">::</operator><name pos:start="10:10" pos:end="10:13">cout</name></name> <operator pos:start="10:15" pos:end="10:16">&lt;&lt;</operator> <operator pos:start="10:18" pos:end="10:18">~</operator><name pos:start="10:19" pos:end="10:19">y</name> <operator pos:start="10:21" pos:end="10:22">&lt;&lt;</operator> <name pos:start="10:24" pos:end="10:32"><name pos:start="10:24" pos:end="10:26">std</name><operator pos:start="10:27" pos:end="10:28">::</operator><name pos:start="10:29" pos:end="10:32">endl</name></name></expr>;</expr_stmt>
    <expr_stmt pos:start="11:5" pos:end="11:37"><expr pos:start="11:5" pos:end="11:36"><name pos:start="11:5" pos:end="11:13"><name pos:start="11:5" pos:end="11:7">std</name><operator pos:start="11:8" pos:end="11:9">::</operator><name pos:start="11:10" pos:end="11:13">cout</name></name> <operator pos:start="11:15" pos:end="11:16">&lt;&lt;</operator> <name pos:start="11:18" pos:end="11:18">y</name> <operator pos:start="11:20" pos:end="11:20">+</operator> <operator pos:start="11:22" pos:end="11:22">~</operator><name pos:start="11:23" pos:end="11:23">y</name> <operator pos:start="11:25" pos:end="11:26">&lt;&lt;</operator> <name pos:start="11:28" pos:end="11:36"><name pos:start="11:28" pos:end="11:30">std</name><operator pos:start="11:31" pos:end="11:32">::</operator><name pos:start="11:33" pos:end="11:36">endl</name></name></expr>;</expr_stmt>
    <expr_stmt pos:start="12:5" pos:end="12:37"><expr pos:start="12:5" pos:end="12:36"><name pos:start="12:5" pos:end="12:13"><name pos:start="12:5" pos:end="12:7">std</name><operator pos:start="12:8" pos:end="12:9">::</operator><name pos:start="12:10" pos:end="12:13">cout</name></name> <operator pos:start="12:15" pos:end="12:16">&lt;&lt;</operator> <name pos:start="12:18" pos:end="12:18">y</name> <operator pos:start="12:20" pos:end="12:20">*</operator> <operator pos:start="12:22" pos:end="12:22">~</operator><name pos:start="12:23" pos:end="12:23">y</name> <operator pos:start="12:25" pos:end="12:26">&lt;&lt;</operator> <name pos:start="12:28" pos:end="12:36"><name pos:start="12:28" pos:end="12:30">std</name><operator pos:start="12:31" pos:end="12:32">::</operator><name pos:start="12:33" pos:end="12:36">endl</name></name></expr>;</expr_stmt>

    <decl_stmt pos:start="14:5" pos:end="14:14"><decl pos:start="14:5" pos:end="14:13"><type pos:start="14:5" pos:end="14:7"><name pos:start="14:5" pos:end="14:7">Set</name></type> <name pos:start="14:9" pos:end="14:9">z</name><argument_list pos:start="14:10" pos:end="14:13">(<argument pos:start="14:11" pos:end="14:12"><expr pos:start="14:11" pos:end="14:12"><literal type="number" pos:start="14:11" pos:end="14:12">14</literal></expr></argument>)</argument_list></decl>;</decl_stmt>

    <decl_stmt pos:start="16:5" pos:end="16:18"><decl pos:start="16:5" pos:end="16:17"><type pos:start="16:5" pos:end="16:7"><name pos:start="16:5" pos:end="16:7">Set</name></type> <name pos:start="16:9" pos:end="16:9">a</name> <init pos:start="16:11" pos:end="16:17">= <expr pos:start="16:13" pos:end="16:17"><name pos:start="16:13" pos:end="16:13">y</name> <operator pos:start="16:15" pos:end="16:15">+</operator> <name pos:start="16:17" pos:end="16:17">z</name></expr></init></decl>;</decl_stmt>
    <expr_stmt pos:start="17:5" pos:end="17:32"><expr pos:start="17:5" pos:end="17:31"><name pos:start="17:5" pos:end="17:13"><name pos:start="17:5" pos:end="17:7">std</name><operator pos:start="17:8" pos:end="17:9">::</operator><name pos:start="17:10" pos:end="17:13">cout</name></name> <operator pos:start="17:15" pos:end="17:16">&lt;&lt;</operator> <name pos:start="17:18" pos:end="17:18">a</name> <operator pos:start="17:20" pos:end="17:21">&lt;&lt;</operator> <name pos:start="17:23" pos:end="17:31"><name pos:start="17:23" pos:end="17:25">std</name><operator pos:start="17:26" pos:end="17:27">::</operator><name pos:start="17:28" pos:end="17:31">endl</name></name></expr>;</expr_stmt>
</block_content>}</block></function>
</unit>

</unit>
EOF

output=$(cat set_pos.xml | ../bin/nameCollector )
expected=$(cat <<EOF
Set is a constructor in C++ file: test_set.cpp at 4:6
i is a int local in C++ file: test_set.cpp at 5:14
Set is a constructor in C++ file: test_set.cpp at 10:6
x is a int parameter in C++ file: test_set.cpp at 10:14
cardinality is a unsigned int function in C++ file: test_set.cpp at 14:19
card is a unsigned int local in C++ file: test_set.cpp at 15:18
i is a size_t local in C++ file: test_set.cpp at 16:16
operator+ is a Set function in C++ file: test_set.cpp at 24:10
rhs is a const Set& parameter in C++ file: test_set.cpp at 24:31
result is a Set local in C++ file: test_set.cpp at 25:9
i is a size_t local in C++ file: test_set.cpp at 26:16
operator* is a Set function in C++ file: test_set.cpp at 32:10
rhs is a const Set& parameter in C++ file: test_set.cpp at 32:31
result is a Set local in C++ file: test_set.cpp at 33:9
i is a size_t local in C++ file: test_set.cpp at 34:16
operator- is a Set function in C++ file: test_set.cpp at 40:10
rhs is a const Set& parameter in C++ file: test_set.cpp at 40:31
result is a Set local in C++ file: test_set.cpp at 41:9
i is a size_t local in C++ file: test_set.cpp at 42:16
operator~ is a Set function in C++ file: test_set.cpp at 48:10
result is a Set local in C++ file: test_set.cpp at 49:9
i is a size_t local in C++ file: test_set.cpp at 50:16
operator== is a bool function in C++ file: test_set.cpp at 56:11
rhs is a const Set& parameter in C++ file: test_set.cpp at 56:33
i is a size_t local in C++ file: test_set.cpp at 57:16
operator<= is a bool function in C++ file: test_set.cpp at 65:11
rhs is a const Set& parameter in C++ file: test_set.cpp at 65:33
i is a size_t local in C++ file: test_set.cpp at 66:16
operator<< is a std::ostream& function in C++ file: test_set.cpp at 74:15
out is a std::ostream& parameter in C++ file: test_set.cpp at 74:40
rhs is a const Set& parameter in C++ file: test_set.cpp at 74:56
i is a size_t local in C++ file: test_set.cpp at 76:16
operator!= is a bool function in C++ file: test_set.cpp at 85:6
lhs is a const Set& parameter in C++ file: test_set.cpp at 85:28
rhs is a const Set& parameter in C++ file: test_set.cpp at 85:44
operator< is a bool function in C++ file: test_set.cpp at 88:6
lhs is a const Set& parameter in C++ file: test_set.cpp at 88:28
rhs is a const Set& parameter in C++ file: test_set.cpp at 88:44
operator>= is a bool function in C++ file: test_set.cpp at 91:6
lhs is a const Set& parameter in C++ file: test_set.cpp at 91:28
rhs is a const Set& parameter in C++ file: test_set.cpp at 91:44
operator> is a bool function in C++ file: test_set.cpp at 94:6
lhs is a const Set& parameter in C++ file: test_set.cpp at 94:28
rhs is a const Set& parameter in C++ file: test_set.cpp at 94:44
NAMECOLLECTOR_SET_HPP_ is a macro in C++ file: test_set.hpp at 2:9
COLLECTION_SIZE is a const unsigned int global in C++ file: test_set.hpp at 6:20
Set is a class in C++ file: test_set.hpp at 9:7
Set is a constructor in C++ file: test_set.hpp at 11:5
Set is a constructor in C++ file: test_set.hpp at 12:5
cardinality is a unsigned int function in C++ file: test_set.hpp at 14:18
operator[] is a bool function in C++ file: test_set.hpp at 15:10
operator+ is a Set function in C++ file: test_set.hpp at 17:9
operator* is a Set function in C++ file: test_set.hpp at 18:9
operator- is a Set function in C++ file: test_set.hpp at 19:9
operator~ is a Set function in C++ file: test_set.hpp at 21:9
operator== is a bool function in C++ file: test_set.hpp at 23:10
operator<= is a bool function in C++ file: test_set.hpp at 24:10
operator<< is a std::ostream& function in C++ file: test_set.hpp at 26:26
member is a bool field in C++ file: test_set.hpp at 29:10
operator!= is a bool function in C++ file: test_set.hpp at 33:6
operator< is a bool function in C++ file: test_set.hpp at 34:6
operator>= is a bool function in C++ file: test_set.hpp at 35:6
operator> is a bool function in C++ file: test_set.hpp at 36:6
main is a int function in C++ file: test_set_main.cpp at 4:5
x is a Set local in C++ file: test_set_main.cpp at 5:9
y is a Set local in C++ file: test_set_main.cpp at 6:9
z is a Set local in C++ file: test_set_main.cpp at 14:9
a is a Set local in C++ file: test_set_main.cpp at 16:9
EOF
)
if [[ "$output" != "$expected" ]]; then
    echo "Test set_pos passed failed!"
    echo "Expected: '$expected'"
    echo "Got:      '$output'"
    exit 1
else
    echo "Test set_pos passed"
fi

exit 0
