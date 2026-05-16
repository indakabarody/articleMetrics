<div id="doi_article-{$article->getId()}" class='articleMetrics'>
    <div class="authors" style="margin-bottom: 5px;">
        {foreach from=$article->getAuthors() item=author name=authorList}
            <div class="consent">
                <b>{$author->getFullName()|escape}{if ($displayAuthorAffiliation && $author->getLocalizedAffiliation()) || ($displayAuthorCountry && ($author->getCountryLocalized() || $author->getCountry()))},{/if}</b>
                {if $displayAuthorAffiliation && $author->getLocalizedAffiliation()}
                    &nbsp;{$author->getLocalizedAffiliation()|escape}{if $displayAuthorCountry && ($author->getCountryLocalized() || $author->getCountry())},{/if}
                {/if}
                {if $displayAuthorCountry && $author->getCountryLocalized()}
                    &nbsp;{$author->getCountryLocalized()|escape}
                {elseif $displayAuthorCountry && $author->getCountry()}
                    &nbsp;{$author->getCountry()|escape}
                {/if}
            </div>
            {if $displayAuthorOrcid && $author->getOrcid()}
                <div class="orcid">
                    {$orcidIcon}
                    <a href="{$author->getOrcid()|escape}" target="_blank">
                        {$author->getOrcid()|escape}
                    </a>
                </div>
            {/if}
        {/foreach}
    </div>
    {assign var=galleys value=$article->getGalleys()}
    {if $displayAbstractViews}
        <img src="https://i.ibb.co.com/4sq7yLG/ico2.png"> {translate key="article.abstract"} views: {$article->getViews()} times
        {if $displayDownloads && $galleys} | {/if}
    {/if}
    {if $displayDownloads && $galleys}
        <img src="https://i.ibb.co.com/8zQW6X2/ico3.png">
        {foreach from=$galleys item=galley name=galleyList} Downloads: {$galley->getViews()} times {if !$smarty.foreach.galleyList.last}|{/if}
        {/foreach}
    {/if}
    {if $displayDoi && $doiUrl}
        <br>
        <img src="https://ia-education.com/journal/public/site/icon-doi.png"> 
        {translate key="plugins.pubIds.doi.readerDisplayName"}:
        <a href="{$doiUrl}">{$doiUrl}</a>
    {/if}
</div>