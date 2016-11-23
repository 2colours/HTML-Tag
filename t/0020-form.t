use v6;
use Test; 
use lib <lib>;

plan 9;

use-ok 'HTML::Tag::Tags', 'HTML::Tag::Tags can be use-d';
use HTML::Tag::Tags;
use-ok 'HTML::Tag::Macro::Form', 'HTML::Tag::Macro::Form can be use-d';
use HTML::Tag::Macro::Form;

ok my $form = HTML::Tag::Macro::Form.new(:nolabel, :action('/')), 'HTML::Tag::Macro::Form instantated';

my @def = ( { username => { }},
	    { password => { }},
	    { submit   => { type  => 'submit',
			    value => 'Login', }},
	  );

$form.def = @def;

is $form.render, '<form method="POST" name="form" action="/"><input name="username" id="form-username" type="text"><input name="password" id="form-password" type="text"><input name="submit" id="form-submit" type="submit" value="Login"></form>', 'HTML::Tag::Macro::Form minimal def';

ok $form = HTML::Tag::Macro::Form.new(:def(@def), :action('/')), 'HTML::Tag::Macro::Form def passed directly in';

is $form.render, '<form method="POST" name="form" action="/"><label>Username<input name="username" id="form-username" type="text"></label><label>Password<input name="password" id="form-password" type="text"></label><label>Submit<input name="submit" id="form-submit" type="submit" value="Login"></label></form>', 'HTML::Tag::Macro::Form with labels';

@def = ( { username => { }},
	 { password => { }},
	 { submit   => { type    => 'submit',
			 value   => 'Login',
			 nolabel => 1 }},
       );

$form.def = @def;

is $form.render, '<form method="POST" name="form" action="/"><label>Username<input name="username" id="form-username" type="text"></label><label>Password<input name="password" id="form-password" type="text"></label><input name="submit" id="form-submit" type="submit" value="Login"></form>', 'HTML::Tag::Macro::Form with labels excluding one';

my %input;
%input<username> = 'mark';

ok $form = HTML::Tag::Macro::Form.new(:input(%input), :def(@def), :action('/')), 'HTML::Tag::Macro::Form input values instatiate';

is $form.render, '<form method="POST" name="form" action="/"><label>Username<input name="username" id="form-username" type="text" value="mark"></label><label>Password<input name="password" id="form-password" type="text"></label><input name="submit" id="form-submit" type="submit" value="Login"></form>', 'HTML::Tag::Macro::Form with value test';
