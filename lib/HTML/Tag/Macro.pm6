use v6;
use HTML::Tag;
use HTML::Tag::Tags;

class HTML::Tag::Macro::CSS is HTML::Tag::link
{
    method do-assignments() {
	callsame;
	$.attr<rel>  = $.rel  || 'stylesheet';
	$.attr<type> = $.type || 'text/css';
    }
}

class HTML::Tag::Macro::Table
{
    has @.rows is rw;
    has $.table-opts is rw = {};

    method row(Bool :$header = False,
	       Hash :$td-opts,
	       Hash :$tr-opts = {},
	       *@cols) {
	
	my @col-objects;
	for @cols.kv -> $i, $col {
	    my $opts = $td-opts{$i}:exists ?? $td-opts{$i} !! {}  ;
	    if ($header) { @col-objects.push: HTML::Tag::th.new(:text($col), |$opts) }
	    else         { @col-objects.push: HTML::Tag::td.new(:text($col), |$opts) }
	}
	@!rows.push: HTML::Tag::tr.new(:text(|@col-objects), |$tr-opts);
    }

    method rows(Hash :$td-opts,
		Hash :$tr-opts = {},
		*@rows) {

	@rows.map: { self.row(:td-opts($td-opts),
			      :tr-opts($tr-opts),
			      |$_ );
		   }
    }

    method render() {
	HTML::Tag::table.new(:text(|@!rows), |$!table-opts).render;
    }
}

=begin pod

=head1 NAME HTML::Tag::Macro

=head1 SYNOPSIS

=head2 CSS
    =begin code
    use HTML::Tag::Macro::CSS;
    my $css = HTML::Tag::Macro::CSS.new(:href('css/file.css'));

    # <link rel="stylesheet" href="css/file.css" type="text/css">
    =end code

=head2 Table

    =begin code
    use HTML::Tag::Macro::Table;
    my $table = HTML::Tag::Macro::Table.new;
    my @data = 'Val 1', 'Val 2', 'Total';
    $table.row(:header, @data);
    @data = 111, 22, 133;
    $table.row(@data);
    $table.render;

    # <table><tr><th>Val 1</th><th>Val 2</th><th>Total</th></tr><tr><td>111</td><td>22</td><td>133</td></tr></table>

    # ... or replace @data above and use rows() for multiple rows with 2-d array
    @data = ((111, 22, 133),
	     (222, 33, 255));
    $table.rows(@data);
    $table.render;

    # <table><tr><th>Val 1</th><th>Val 2</th><th>Total</th></tr><tr><td>111</td><td>22</td><td>133</td></tr><tr><td>222</td><td>33</td><td>255</td></tr></table>   
    =end code

=head1 DETAIL

Macros are created and rendered tags but offer some automation.

=head2 CSS

Creates a ::link tag for CSS files

HTML::Tag::Macro::CSS accepts the same options as the ::link tag, but
additionally :rel (defaulting to "stylesheet") and :type (defaulting
to "text/css".

=head2 Table

Creates a combination of ::th ::td ::tr tags swallowed by a ::table
tag to help automate the creation of an HTML table.

HTML::Tag::Macro::Table has 2 methods: C<row()> and C<rows()>.

row(@array_of_table_row_data) - each element of the array will be
surrounded by ::td tags in the row.

row(:header) designates the row as an HTML header row (so ::th tags
will be u sed instead of ::td tags for that row).

row(:td-opts) applies ::td tag options to select ::td elements
generated in the row. That element is selected by specifying the
numeric key and the value becomes the options to apply. For example,
to apply options to the second td element,

    =begin code
    $td-opts = %( 2 => {class => 'pretty'});
    =end code

row(:tr-opts) applies ::tr tag options to the row.

If you want to generate the table by specifying multiple rows, you can
do so with a 2-d array, where each element is a list of table data,
using the rows() method instead of row().

    =begin code
    @data = ((34, 53, 23),
             (43, 23, 55),
             (27, 32, 66));
    $table.rows(@data);
    =end code

The rows() method also takes the :td-opts and :tr-opts options, but
they are passed to every single row.

Table options can be specified when instantiating the table macro with
new using the (:table-opts) hash.

=head1 AUTHOR

Mark Rushing seatek@gmail.com

=end pod
    
