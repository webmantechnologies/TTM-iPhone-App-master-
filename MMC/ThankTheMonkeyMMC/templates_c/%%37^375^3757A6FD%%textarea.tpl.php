<?php require_once(SMARTY_CORE_DIR . 'core.load_plugins.php');
smarty_core_load_plugins(array('plugins' => array(array('block', 'style_block', 'editors/textarea.tpl', 7, false),)), $this); ?>
<?php if (! $this->_tpl_vars['TextArea']->GetReadOnly()): ?>
<textarea
    data-editor="true"
    data-editor-class="TextArea"
    data-field-name="<?php echo $this->_tpl_vars['TextArea']->GetFieldName(); ?>
"
    data-editable="true"
    <?php $this->_tag_stack[] = array('style_block', array()); $_block_repeat=true;smarty_block_style_block($this->_tag_stack[count($this->_tag_stack)-1][1], null, $this, $_block_repeat);while ($_block_repeat) { ob_start(); ?>
        <?php echo $this->_tpl_vars['TextArea']->GetCustomAttributes(); ?>

    <?php $_block_content = ob_get_contents(); ob_end_clean(); $_block_repeat=false;echo smarty_block_style_block($this->_tag_stack[count($this->_tag_stack)-1][1], $_block_content, $this, $_block_repeat); }  array_pop($this->_tag_stack); ?>
    id="<?php echo $this->_tpl_vars['TextArea']->GetName(); ?>
"
    name="<?php echo $this->_tpl_vars['TextArea']->GetName(); ?>
"
    <?php if ($this->_tpl_vars['TextArea']->GetColumnCount() != null): ?>
    cols="<?php echo $this->_tpl_vars['TextArea']->GetColumnCount(); ?>
"<?php endif; ?>
    <?php if ($this->_tpl_vars['TextArea']->GetRowCount() != null): ?>
    rows="<?php echo $this->_tpl_vars['TextArea']->GetRowCount(); ?>
"<?php endif; ?>
    <?php echo $this->_tpl_vars['Validators']['InputAttributes']; ?>
><?php echo $this->_tpl_vars['TextArea']->GetValue(); ?>
</textarea>
<?php else: ?>
<span
    data-editor="true"
    data-editor-class="TextArea"
    data-field-name="<?php echo $this->_tpl_vars['TextArea']->GetFieldName(); ?>
"
    data-editable="false"><?php echo $this->_tpl_vars['TextArea']->GetValue(); ?>

</span>
<?php endif; ?>