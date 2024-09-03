<div id="doi_article-{$article->getId()}" class='articleMetrics'>
    {assign var=galleys value=$article->getGalleys()}
    <img src="https://i.ibb.co.com/4sq7yLG/ico2.png"> {translate key="article.abstract"} views: {$article->getViews()} times | <img src="https://i.ibb.co.com/8zQW6X2/ico3.png">
    {if $galleys}
        {foreach from=$galleys item=galley name=galleyList} Downloads: {$galley->getViews()} times |
        {/foreach}
    {/if}
    <img src="https://ia-education.com/journal/public/site/icon-doi.png"> 
    {translate key="plugins.pubIds.doi.readerDisplayName"}:
    <a href="{$doiUrl}">{$doiUrl}</a>
</div>