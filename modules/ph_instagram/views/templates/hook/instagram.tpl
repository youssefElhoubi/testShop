
<div class="ybc_instagram ybc_instagram_hook_home zooming_enabled is_17">
    <div class="wraper_title_section">
        <h4 class="h1 products-section-title text-uppercase home_title_section">
            <a class="h1 products-section-title text-uppercase home_title_section" href="{$PH_INSTAGRAM_PROFILE_URL|escape:'quotes'}" target="_blank">
                {l s='Follow us on Instagram' mod='ph_instagram'}
            </a>
        </h4>
        <span class="sub_title_section">
           <a class="ybc_instagram_user" href="{$PH_INSTAGRAM_PROFILE_URL|escape:'quotes'}" target="_blank">
                @{$PH_INSTAGRAM_DISPLAY_NAME|escape:'html':'UTF-8'}
           </a>
        </span>
        <div class="line_sub"></div>
    </div>
    {if $IMGs}
        {*<div class="top_footer_instagram">
            {if $PH_INSTAGRAM_FOLLOW_US}
                {if $PH_INSTAGRAM_PROFILE_URL}
                    <a class="ph-insta-follow-us" href="{$PH_INSTAGRAM_PROFILE_URL|escape:'quotes'}" target="_blank">{$PH_INSTAGRAM_FOLLOW_US|escape:'html':'UTF-8'}</a>
                {else}
                    <span class="ph-insta-follow-us">{$PH_INSTAGRAM_FOLLOW_US|escape:'html':'UTF-8'}</span>
                {/if}
            {/if}
            {if $PH_INSTAGRAM_DISPLAY_NAME}
                {if $PH_INSTAGRAM_PROFILE_URL}
                    <a class="ph-insta-display-name" href="{$PH_INSTAGRAM_PROFILE_URL|escape:'quotes'}" target="_blank">@{$PH_INSTAGRAM_DISPLAY_NAME|escape:'html':'UTF-8'}</a>
                {else}
                    <span class="ph-insta-display-name">@{$PH_INSTAGRAM_DISPLAY_NAME|escape:'html':'UTF-8'}</span>
                {/if}
            {/if}
        </div>*}
        <ul id="footer_instagram" class="instagram_list_img">
            {assign var='ik' value=0}
            {foreach $IMGs as $key=>$img}
                {assign var='ik' value=$ik+1}
                {if $ik <= $PH_INSTAGRAM_IMG_NUMBER}
                    <li class="instagram_item_img col-xs-4 col-sm-4 col-md-4">
                        <a class="ybc_instagram_fancy" href="{if $img.is_video}#ph_insta_video_{$key+1}{else}{$img.standard_resolution|escape:'html':'UTF-8'}{/if}" data-media-type="{if $img.is_video}video{else}image{/if}">
                            <img {if $img.caption}alt="{$img.caption|escape:'html':'UTF-8'}"{/if} src="{$img.thumbnail|escape:'html':'UTF-8'}" alt=""/>
                        </a>
                        {if $img.is_video}
                            <video controls style="display: none; padding: 0; width: auto;" id="ph_insta_video_{$key+1}">
                                <source src="{$img.standard_resolution|escape:'html':'UTF-8'}" type="video/mp4">
                                Your browser doesn't support HTML5 video tag.
                            </video>
                        {/if}
                    </li>
                {/if}
            {/foreach}
        </ul>
    {else}
        <ul id="footer_instagram" class="instagram_list_img not-found">
            {l s='Media not found or invalid request.' mod='ph_instagram'}
        </ul>
    {/if}
</div>