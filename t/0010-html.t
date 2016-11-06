use v6;
use Test; 
use lib <./lib ./t/lib>;

plan 10;

use-ok 'HG::HTML', 'HG::HTML can be use-d';
use HG::HTML;

# P and class/id attributes
is HTML::p.new(:text('testing & here')).render, '<p>testing &amp; here</p>', 'HTML::p works ok';
is HTML::p.new(text => 'test', :id('myID')).render, '<p id="myID">test</p>', 'HTML::p.id works';
is HTML::p.new(text => 'test', :class('myclass')).render, '<p class="myclass">test</p>', 'HTML::p.class works';
is HTML::p.new(:text('test'), :class('MYClass'), :id('myNAME')).render, '<p id="myNAME" class="MYClass">test</p>', 'HTML::p.class and .id both work together';

# Anchor
is HTML::a.new(:text('My Page'), :href('http://mydomain.com')).render, '<a href="http://mydomain.com">My Page</a>', 'HTML::a works';

# DIV & SPAN
is HTML::div.new(:text('My Div')).render, '<div>My Div</div>', 'HTML::div works';
is HTML::span.new(:text('My Span')).render, '<span>My Span</span>', 'HTML::span works';

# FORM
is HTML::form.new(:action('/myscript/is') :id('myid')).render, '<form id="myid" action="/myscript/is"></form>', 'HTML::form works';

# CSS Macro
is HTML::Macro::CSS.new(:href('css/file.css')).render,
'<link rel="stylesheet" type="text/css" href="css/file.css">', 'HTML::Macro:CSS works';



say HTML::p.new(:text('This is my paragraph'), :class('pretty')).render;







my $link = HTML::a.new(:text('paragraph & paper'), :href('http://dom.com'));
say HTML::p.new(:text("This is my & my dog's ", $link, " to see the world & something"), :class('pretty')).render;
