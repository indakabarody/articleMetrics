<div id="doi_article-{$article->getId()}" class='articleMetrics' style="display: none;">
    <div class="authors" style="margin-bottom: 5px;">
        {if !$displayAuthorAffiliation && !$displayAuthorCountry}
            {foreach from=$article->getAuthors() item=author name=authorList}
                {$author->getFullName()|escape}{if !$smarty.foreach.authorList.last}, {/if}
            {/foreach}
        {else}
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
        {/if}
    </div>
    {assign var=galleys value=$article->getGalleys()}
    {assign var=hasPdfGalley value=false}
    {if $galleys}
        {foreach from=$galleys item=galley}
            {if $galley->getLabel()|trim|lower == 'pdf'}
                {assign var=hasPdfGalley value=true}
            {/if}
        {/foreach}
    {/if}
    {if $displayAbstractViews}
        <img src="{$articleMetricsPluginUrl|escape}/images/icon-views.png" alt=""> {if $article->getViews() > 1}{translate key="plugins.generic.articleMetrics.abstractViews"}{else}{translate key="plugins.generic.articleMetrics.abstractView"}{/if}: {$article->getViews()} times
        {if $displayDownloads && $hasPdfGalley} | {/if}
    {/if}
    {if $displayDownloads && $hasPdfGalley}
        <img src="{$articleMetricsPluginUrl|escape}/images/icon-downloads.png" alt="">
        {assign var=isFirstPdf value=true}
        {foreach from=$galleys item=galley}
            {if $galley->getLabel()|trim|lower == 'pdf'}
                {assign var=downloadCount value=$galley->getViews()}
                {if !$isFirstPdf} | {/if}
                <span class="article-pdf-downloads">
                    {if $downloadCount > 1}{translate key="plugins.generic.articleMetrics.downloads"}{else}{translate key="plugins.generic.articleMetrics.download"}{/if}: {$downloadCount} times
                </span>
                {assign var=isFirstPdf value=false}
            {/if}
        {/foreach}
    {/if}
    {if $displayDoi && $doiUrl}
        {if $displayAbstractViews || ($displayDownloads && $hasPdfGalley)} | {/if}
        <img src="{$articleMetricsPluginUrl|escape}/images/icon-doi.png" alt="DOI"> DOI:
        <a href="{$doiUrl}">
            {$doiUrl}
        </a>
    {/if}
    {if $displayPublicationDate && $datePublished}
        {if $displayAbstractViews || ($displayDownloads && $hasPdfGalley) || ($displayDoi && $doiUrl)} | {/if}
        {translate key="plugins.generic.articleMetrics.published"}: {$datePublished|date_format:"%Y-%m-%d"}
    {/if}
    {if ($displayDoi && $doiUrl) || ($displayPublicationDate && $datePublished) || $displayAbstractViews || ($displayDownloads && $hasPdfGalley)}
        <br>
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