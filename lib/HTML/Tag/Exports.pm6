use v6;
use HTML::Tag::Tags;

unit class HTML::Tag::Exports;

sub tag($tag-name = 'p', *%opts) is export {
    HTML::Tag::{$tag-name}.new(|%opts);
}

