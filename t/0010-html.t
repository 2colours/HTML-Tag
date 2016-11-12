use v6;
use Test; 
use lib <lib>;

plan 24;

use-ok 'HTML::Tag::Tags', 'HTML::Tag::Tags can be use-d';
use HTML::Tag::Tags;
use-ok 'HTML::Tag::Macro', 'HTML::Tag::Macro can be use-d';
use HTML::Tag::Macro;

# P and class/id attributes
is HTML::Tag::p.new(:text('testing & here')).render, '<p>testing &amp; here</p>', 'HTML::Tag::p works ok';
is HTML::Tag::p.new(text => 'test', :id('myID')).render, '<p id="myID">test</p>', 'HTML::Tag::p.id works';
is HTML::Tag::p.new(text => 'test', :class('myclass')).render, '<p class="myclass">test</p>', 'HTML::Tag::p.class works';
is HTML::Tag::p.new(:text('test'), :class('MYClass'), :id('myNAME')).render, '<p id="myNAME" class="MYClass">test</p>', 'HTML::Tag::p.class and .id both work together';

# Anchor
is HTML::Tag::a.new(:text('My Page'), :href('http://mydomain.com')).render, '<a href="http://mydomain.com">My Page</a>', 'HTML::Tag::a works';

# Link
is HTML::Tag::link.new(:href('http://mydomain.com'), :rel('stylesheet'), :type('text/css')).render, '<link rel="stylesheet" href="http://mydomain.com" type="text/css">', 'HTML::Tag::link works';

# Swallowing another tag
my $tag = HTML::Tag::a.new(:text('My Page'),
			   :href('http://mydomain.com')),
is HTML::Tag::p.new(:text('test ', $tag), :id('myID')).render,
	            '<p id="myID">test <a href="http://mydomain.com">My Page</a></p>', 'HTML::Tag swallowing other tags works';


# DIV & SPAN
is HTML::Tag::div.new(:text('My Div'), :style('funnyfont')).render, '<div style="funnyfont">My Div</div>', 'HTML::Tag::div works';
is HTML::Tag::span.new(:text('My Span')).render, '<span>My Span</span>', 'HTML::Tag::span works';

# Form
is HTML::Tag::form.new(:action('/myscript/is') :id('myid')).render, '<form id="myid" action="/myscript/is"></form>', 'HTML::Tag::form works';
is HTML::Tag::input.new(:value('testval'), :min(0)).render, '<input min="0" type="text" value="testval">', 'HTML::Tag::input works';
is HTML::Tag::input.new(:type('radio'), :checked(True)).render, '<input checked type="radio">', 'HTML::Tag::input radio checked works';
is HTML::Tag::textarea.new(:text('This is in the box'), :id('boxy')).render, '<textarea id="boxy">This is in the box</textarea>', 'HTML::Tag::textarea works';
$tag = HTML::Tag::input.new(:name('fingers'));
is HTML::Tag::fieldset.new(:form('myform'), :text($tag)).render, '<fieldset form="myform"><input name="fingers" type="text"></fieldset>', 'HTML::Tag::fieldset works ok';
my $legend = HTML::Tag::legend.new(:text('Great fields'));
is HTML::Tag::fieldset.new(:form('myform'), :text($legend, $tag)).render, '<fieldset form="myform"><legend>Great fields</legend><input name="fingers" type="text"></fieldset>', 'HTML::Tag::legend works ok';

# CSS Macro
is HTML::Tag::Macro::CSS.new(:href('css/file.css')).render,
'<link rel="stylesheet" href="css/file.css" type="text/css">', 'HTML::Tag::Macro:CSS works';

# Image
is HTML::Tag::img.new(:src('/img/foo.jpg'),
		      :width(100), :height(150),
		      :alt('funny pic'),
		      :border(0)).render, '<img height="150" alt="funny pic" border="0" width="100" src="/img/foo.jpg">', 'HTML::Tag::img works.';

# Table
my $th1 = HTML::Tag::th.new(:text('Col1'));
my $th2 = HTML::Tag::th.new(:text('Col2'));
my $tr1 = HTML::Tag::tr.new(:text($th1, $th2));
my $td1 = HTML::Tag::td.new(:text('My data 1'), :class('italic'));
my $td2 = HTML::Tag::td.new(:text('My data 2'), :class('italic'));
my $tr2 = HTML::Tag::tr.new(:text($td1, $td2));
is HTML::Tag::table.new(:text($tr1, $tr2)).render, '<table><tr><th>Col1</th><th>Col2</th></tr><tr><td class="italic">My data 1</td><td class="italic">My data 2</td></tr></table>', 'HTML::Tag::table works';

# HTML, head, title and body
my $title = HTML::Tag::title.new(:text('My Title'));
my $head  = HTML::Tag::head.new(:text($title));
my $body  = HTML::Tag::body.new(:text('My page is here'));
is HTML::Tag::html.new(:text($head, $body)).render, '<html><head><title>My Title</title></head><body>My page is here</body></html>', 'HTML::Tag::html, head, title and body work ok';

# Table Macro
my $table = HTML::Tag::Macro::Table.new;
my @data = 'Col1', 'Col2', 'Col3';
$table.row(:header(True), @data);
@data = 11, 22, 33;
$table.row(@data);
is $table.render, '<table><tr><th>Col1</th><th>Col2</th><th>Col3</th></tr><tr><td>11</td><td>22</td><td>33</td></tr></table>', 'HTML::Tag::Macro::Table works';

# Table Macro with td options
$table = HTML::Tag::Macro::Table.new;
@data = 'Col1', 'Col2', 'Col3';
$table.row(:header(True), @data);
@data = 11, 22, 33;
$table.row(@data);
@data = 111, 222, 333;
my $td-opts = %(1 => {class => 'pretty'},
		2 => {class => 'pretty',
		      id    => 'lastone'});
$table.row(:td-opts($td-opts), @data);
is $table.render, '<table><tr><th>Col1</th><th>Col2</th><th>Col3</th></tr><tr><td>11</td><td>22</td><td>33</td></tr><tr><td>111</td><td class="pretty">222</td><td id="lastone" class="pretty">333</td></tr></table>', 'HTML::Tag::Macro::Table works with td-opts';

$table = HTML::Tag::Macro::Table.new(:table-opts(id => 'mytable'));
@data = 'Col1', 'Col2', 'Col3';
$table.row(:header(True), @data);
@data = 11, 22, 33;
my $tr-opts = %(class => 'pretty');
$table.row(:tr-opts($tr-opts), @data);
@data = 111, 222, 333;
$table.row(@data);
is $table.render, '<table id="mytable"><tr><th>Col1</th><th>Col2</th><th>Col3</th></tr><tr class="pretty"><td>11</td><td>22</td><td>33</td></tr><tr><td>111</td><td>222</td><td>333</td></tr></table>', 'HTML::Tag::Macro::Table works with tr-opts';
