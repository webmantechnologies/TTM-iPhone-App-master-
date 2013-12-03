<?php ob_start(); ?>
<body>
    <table class="grid" style="width: auto">
        <tr><th class="even" ><?php echo $this->_tpl_vars['Viewer']->GetCaption(); ?>
</th></tr>
        <tr class="even"><td class="even" style="padding: 10px; text-align: left"><p align="justify"><?php echo $this->_tpl_vars['Viewer']->GetValue($this->_tpl_vars['Renderer']); ?>
</p></td></tr>
        <tr class="even"><td class="even"><a href="#" onClick="window.close(); return false;"><?php echo $this->_tpl_vars['Captions']->GetMessageString('CloseWindow'); ?>
</a></td></tr>
    </table>
</body>
<?php $this->_smarty_vars['capture']['default'] = ob_get_contents();  $this->assign('ContentBlock', ob_get_contents());ob_end_clean(); ?>

<?php $_smarty_tpl_vars = $this->_tpl_vars;
$this->_smarty_include(array('smarty_include_tpl_file' => "common/base_page_template.tpl", 'smarty_include_vars' => array()));
$this->_tpl_vars = $_smarty_tpl_vars;
unset($_smarty_tpl_vars);
 ?>