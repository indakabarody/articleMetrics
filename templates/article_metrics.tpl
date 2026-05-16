<div id="doi_article-{$article->getId()}" class='articleMetrics' style="display: none;">
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
        <img src="https://i.ibb.co.com/K592vF7/ico2.png"> {if $article->getViews() > 1}{translate key="plugins.generic.articleMetrics.abstractViews"}{else}{translate key="plugins.generic.articleMetrics.abstractView"}{/if} : {$article->getViews()} times
        {if $displayDownloads && $galleys} | {/if}
    {/if}
    {if $displayDownloads && $galleys}
        <img src="https://i.ibb.co.com/ckyfpZR/ico3.png">
        {foreach from=$galleys item=galley name=galleyList} {if $galley->getViews() > 1}{translate key="plugins.generic.articleMetrics.downloads"}{else}{translate key="plugins.generic.articleMetrics.download"}{/if}: {$galley->getViews()} times {if !$smarty.foreach.galleyList.last}|{/if}
        {/foreach}
    {/if}
    {if $displayDoi && $doiUrl}
        {if $displayAbstractViews || ($displayDownloads && $galleys)} | {/if}
        <img src="https://ia-education.com/journal/public/site/icon-doi.png"> DOI :
        <a href="{$doiUrl}">
            {$doiUrl}
            <br>
        </a>
    {/if}
</div>

<script>
    (function() {ldelim}
        var articleMetrics = document.getElementById('doi_article-{$article->getId()}');
        if (articleMetrics) {ldelim}
            var summary = articleMetrics.closest('.obj_article_summary');
            if (summary) {ldelim}
                var newAuthors = articleMetrics.querySelector('.authors');
                var oldAuthors = summary.querySelector('.meta .authors');
                if (oldAuthors && newAuthors) {ldelim}
                    oldAuthors.parentNode.replaceChild(newAuthors, oldAuthors);
                {rdelim}
                
                // Pindahkan elemen metrik ke luar wrapper articleMetrics
                var parent = articleMetrics.parentNode;
                while (articleMetrics.firstChild) {ldelim}
                    parent.insertBefore(articleMetrics.firstChild, articleMetrics);
                {rdelim}
                parent.removeChild(articleMetrics);
            {rdelim} else {ldelim}
                articleMetrics.style.display = 'block';
            {rdelim}
        {rdelim}
    {rdelim})();
</script>