use v6;
use Test; 
use lib <lib>;

plan 5;

use-ok 'HTML::Tag::Tags', 'HTML::Tag::Tags can be use-d';
use HTML::Tag::Tags;
use-ok 'HTML::Tag::Macro::Form', 'HTML::Tag::Macro::Form can be use-d';
use HTML::Tag::Macro::Form;

ok my $form = HTML::Tag::Macro::Form.new, 'HTML::Tag::Macro::Form instantated';

my @def = ( { username => { }},
	    { password => { }},
	  );

$form.def = @def;

is $form.render, '<form method="POST" name="form"><input name="username" id="form-username" type="text"><input name="password" id="form-password" type="text"></form>', 'HTML::Tag::Macro::Form minimal def';

