<?php require_once(SMARTY_CORE_DIR . 'core.load_plugins.php');
smarty_core_load_plugins(array('plugins' => array(array('block', 'style_block', 'editors/image_uploader.tpl', 9, false),)), $this); ?>
<?php if (! $this->_tpl_vars['Uploader']->GetReadOnly()): ?>
<?php if ($this->_tpl_vars['RenderText']): ?>
<?php if ($this->_tpl_vars['Uploader']->GetShowImage() && ! $this->_tpl_vars['HideImage']): ?>
<img src="<?php echo $this->_tpl_vars['Uploader']->GetLink(); ?>
"><br/>
<?php endif; ?>
<input checked="checked" type="radio" value="Keep" name="<?php echo $this->_tpl_vars['Uploader']->GetName(); ?>
_action"><?php echo $this->_tpl_vars['Captions']->GetMessageString('KeepImage'); ?>

<input type="radio" value="Remove" name="<?php echo $this->_tpl_vars['Uploader']->GetName(); ?>
_action"><?php echo $this->_tpl_vars['Captions']->GetMessageString('RemoveImage'); ?>

<input type="radio" value="Replace" name="<?php echo $this->_tpl_vars['Uploader']->GetName(); ?>
_action"><?php echo $this->_tpl_vars['Captions']->GetMessageString('ReplaceImage'); ?>
<br>
<input type="file" name="<?php echo $this->_tpl_vars['Uploader']->GetName(); ?>
_filename" <?php $this->_tag_stack[] = array('style_block', array()); $_block_repeat=true;smarty_block_style_block($this->_tag_stack[count($this->_tag_stack)-1][1], null, $this, $_block_repeat);while ($_block_repeat) { ob_start(); ?> <?php echo $this->_tpl_vars['Uploader']->GetCustomAttributes(); ?>
 <?php $_block_content = ob_get_contents(); ob_end_clean(); $_block_repeat=false;echo smarty_block_style_block($this->_tag_stack[count($this->_tag_stack)-1][1], $_block_content, $this, $_block_repeat); }  array_pop($this->_tag_stack); ?>
    onchange="if (this.form.<?php echo $this->_tpl_vars['Uploader']->GetName(); ?>
_action[2]) this.form.<?php echo $this->_tpl_vars['Uploader']->GetName(); ?>
_action[2].checked=true;">
<?php endif; ?>
<?php else: ?>
<?php if ($this->_tpl_vars['RenderText']): ?>
<?php if ($this->_tpl_vars['Uploader']->GetShowImage() && ! $this->_tpl_vars['HideImage']): ?>
<img src="<?php echo $this->_tpl_vars['Uploader']->GetLink(); ?>
"><br/>
<?php else: ?>
<a class="image" target="_blank" title="download" href="<?php echo $this->_tpl_vars['Uploader']->GetLink(); ?>
">Download file</a>
<?php endif; ?>
<?php endif; ?>
<?php endif; ?>