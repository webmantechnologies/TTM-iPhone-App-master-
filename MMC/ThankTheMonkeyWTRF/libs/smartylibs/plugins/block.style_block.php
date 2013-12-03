<?php

function smarty_block_style_block($params, $content, &$smarty)
{
    if ($content)
    {
        $result = $content;
        $result = str_replace("\n", '', $result);
        $result = str_replace("\r", '', $result);
        return 'style="' . $result . '"';
    }
}

?>
