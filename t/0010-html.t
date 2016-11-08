use v6;
use Test; 
use lib <lib>;

plan 13;

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
is HTML::Tag::div.new(:text('My Div'), :style('funnyfont')).render, '<div style="funnyfont">My Div</div>', 'HTML::Tag::div works';
is HTML::Tag::span.new(:text('My Span')).render, '<span>My Span</span>', 'HTML::Tag::span works';

# FORM
is HTML::Tag::form.new(:action('/myscript/is') :id('myid')).render, '<form id="myid" action="/myscript/is"></form>', 'HTML::Tag::form works';
is HTML::Tag::input.new(:value('testval'), :min(0)).render, '<input min="0" type="text" value="testval">', 'HTML::Tag::input works';


# CSS Macro
is HTML::Tag::Macro::CSS.new(:href('css/file.css')).render,
'<link rel="stylesheet" type="text/css" href="css/file.css">', 'HTML::Tag::Macro:CSS works';

# Image
is HTML::Tag::img.new(:src('/img/foo.jpg'),
		      :width(100), :height(150),
		      :alt('funny pic'),
		      :border(0)).render, '<img height="150" alt="funny pic" border="0" width="100" src="/img/foo.jpg">', 'HTML::Tag::img works.';

# Swallowing another tag
my $tag = HTML::Tag::a.new(:text('My Page'),
			   :href('http://mydomain.com')),
is HTML::Tag::p.new(:text('test ', $tag), :id('myID')).render,
	            '<p id="myID">test <a href="http://mydomain.com">My Page</a></p>', 'HTML::Tag swallowing other tags works';


