use v6;
use Test; 
use lib <lib>;

plan 12;

use-ok 'HTML::Tag::Tags', 'HTML::Tag::Tags can be use-d';
use HTML::Tag::Tags;
use-ok 'HTML::Tag::Macros', 'HTML::Tag::Macros can be use-d';
use HTML::Tag::Macros;

# P and class/id attributes
is HTML::Tag::p.new(:text('testing & here')).render, '<p>testing &amp; here</p>', 'HTML::Tag::p works ok';
is HTML::Tag::p.new(text => 'test', :id('myID')).render, '<p id="myID">test</p>', 'HTML::Tag::p.id works';
is HTML::Tag::p.new(text => 'test', :class('myclass')).render, '<p class="myclass">test</p>', 'HTML::Tag::p.class works';
is HTML::Tag::p.new(:text('test'), :class('MYClass'), :id('myNAME')).render, '<p id="myNAME" class="MYClass">test</p>', 'HTML::Tag::p.class and .id both work together';

# Anchor
is HTML::Tag::a.new(:text('My Page'), :href('http://mydomain.com')).render, '<a href="http://mydomain.com">My Page</a>', 'HTML::Tag::a works';

# DIV & SPAN
is HTML::Tag::div.new(:text('My Div')).render, '<div>My Div</div>', 'HTML::Tag::div works';
is HTML::Tag::span.new(:text('My Span')).render, '<span>My Span</span>', 'HTML::Tag::span works';

# FORM
is HTML::Tag::form.new(:action('/myscript/is') :id('myid')).render, '<form id="myid" action="/myscript/is"></form>', 'HTML::Tag::form works';

# CSS Macro
is HTML::Tag::Macro::CSS.new(:href('css/file.css')).render,
'<link rel="stylesheet" type="text/css" href="css/file.css">', 'HTML::Tag::Macro:CSS works';

# Swallowing another tag
my $tag = HTML::Tag::a.new(:text('My Page'),
			   :href('http://mydomain.com')),
is HTML::Tag::p.new(:text('test ', $tag), :id('myID')).render,
	            '<p id="myID">test <a href="http://mydomain.com">My Page</a></p>', 'HTML::Tag swallowing other tags works';


