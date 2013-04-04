README
======

nesta-plugin-search is a plugin for the Nesta CMS use
[Ferret](https://github.com/dbalmain/ferret) to index and search your site.

Installation
------------

To install it as a gem add nesta-search to the `Gemfile` in your Nesta
project, and then re-run `bundle`:

    $ echo "gem 'nesta-plugin-search'" >> Gemfile
    $ bundle

Text Search Usage
-----------------

Create a `/search` page -- `content/pages/search.haml` -- here's an example:

    %h1 Search Results
    - if (results = search_results( search_index, params[:q] )) && !results.empty?
      %section.articles= article_summaries(results)
    - else
      %h3 No articles found!

Add a searchbox to your layout, something like:

    %form{:action => "/search"}
        %input{:type => "text", :name => "q", :value => "#{params[:q]||''}"}


Text Search Configuration
-------------------------

Set `search_index_timeout` to the number of seconds you want your default indexes to
be stored for. By default, this is `false`, which never expires the index. It should
be noted that reindexing is slow.

Set `search_ignore_list` to the abspath of the pages you want to be excluded from the
search index. "/search" is forcefully excluded always and "/" is the default.

Example:

    search_index_timeout: 3600
    search_ignore_list:
    - /
    - /foo
    - /foo/bar

> IMPORTANT NOTE: If you're not using "/search" as your search page, please add it to
> this list or bad things may happen.

Advanced Usage Notes
--------------------

Provided Index Helpers:

- `search_index` -- an index of all pages and articles.
- `article_index` -- an index of articles only.

Creating your own index:

    - my_index = Nesta::Plugin::Search::Index.new( :my_find_method ).index
    %h1 Search Results
    - if (results = search_results( my_index, params[:q] )) && !results.empty?
      %section.articles= article_summaries(results)
    - else
      %h3 No articles found!

If you want to pregenerate your cache to disk and load it that way, it would be something
like this:

    - existing_index = Ferret::Index::Index.new(:path => "/path/to/existing/index")
    %h1 Search Results
    - if (results = search_results( existing_index, params[:q] )) && !results.empty?
      %section.articles= article_summaries(results)
    - else
      %h3 No articles found!

