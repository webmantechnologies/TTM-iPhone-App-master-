<?php require_once(SMARTY_CORE_DIR . 'core.load_plugins.php');
smarty_core_load_plugins(array('plugins' => array(array('function', 'n', 'editors/text_edit.tpl', 3, false),array('block', 'style_block', 'editors/text_edit.tpl', 18, false),)), $this); ?>
<?php echo ''; ?><?php if (! $this->_tpl_vars['TextEdit']->GetReadOnly()): ?><?php echo '<input '; ?><?php echo smarty_function_n(array(), $this);?><?php echo 'data-editor="true" '; ?><?php echo smarty_function_n(array(), $this);?><?php echo 'data-editor-class="TextEdit" '; ?><?php echo smarty_function_n(array(), $this);?><?php echo 'data-field-name="'; ?><?php echo $this->_tpl_vars['TextEdit']->GetFieldName(); ?><?php echo '" '; ?><?php echo smarty_function_n(array(), $this);?><?php echo 'data-editable="true" '; ?><?php echo smarty_function_n(array(), $this);?><?php echo ''; ?><?php if ($this->_tpl_vars['TextEdit']->GetPasswordMode()): ?><?php echo 'type="password" '; ?><?php echo smarty_function_n(array(), $this);?><?php echo ''; ?><?php endif; ?><?php echo 'class="sm_text" '; ?><?php echo smarty_function_n(array(), $this);?><?php echo 'id="'; ?><?php echo $this->_tpl_vars['TextEdit']->GetName(); ?><?php echo '" '; ?><?php echo smarty_function_n(array(), $this);?><?php echo 'name="'; ?><?php echo $this->_tpl_vars['TextEdit']->GetName(); ?><?php echo '" '; ?><?php echo smarty_function_n(array(), $this);?><?php echo 'value="'; ?><?php echo $this->_tpl_vars['TextEdit']->GetHTMLValue(); ?><?php echo '" '; ?><?php echo smarty_function_n(array(), $this);?><?php echo ''; ?><?php if ($this->_tpl_vars['TextEdit']->GetSize() != null): ?><?php echo 'size="'; ?><?php echo $this->_tpl_vars['TextEdit']->GetSize(); ?><?php echo '" '; ?><?php echo smarty_function_n(array(), $this);?><?php echo ''; ?><?php endif; ?><?php echo ''; ?><?php $this->_tag_stack[] = array('style_block', array()); $_block_repeat=true;smarty_block_style_block($this->_tag_stack[count($this->_tag_stack)-1][1], null, $this, $_block_repeat);while ($_block_repeat) { ob_start(); ?><?php echo ''; ?><?php echo $this->_tpl_vars['TextEdit']->GetCustomAttributes(); ?><?php echo ''; ?><?php if ($this->_tpl_vars['TextEdit']->GetSize() != null): ?><?php echo 'width: auto;'; ?><?php endif; ?><?php echo ''; ?><?php $_block_content = ob_get_contents(); ob_end_clean(); $_block_repeat=false;echo smarty_block_style_block($this->_tag_stack[count($this->_tag_stack)-1][1], $_block_content, $this, $_block_repeat); }  array_pop($this->_tag_stack); ?><?php echo ''; ?><?php if ($this->_tpl_vars['TextEdit']->GetMaxLength() != null): ?><?php echo 'maxlength="'; ?><?php echo $this->_tpl_vars['TextEdit']->GetMaxLength(); ?><?php echo '" '; ?><?php echo smarty_function_n(array(), $this);?><?php echo ''; ?><?php endif; ?><?php echo ''; ?><?php echo $this->_tpl_vars['Validators']['InputAttributes']; ?><?php echo ' '; ?><?php echo smarty_function_n(array(), $this);?><?php echo '>'; ?><?php else: ?><?php echo ''; ?><?php if (! $this->_tpl_vars['TextEdit']->GetPasswordMode()): ?><?php echo '<span '; ?><?php echo smarty_function_n(array(), $this);?><?php echo 'data-editor="true" '; ?><?php echo smarty_function_n(array(), $this);?><?php echo 'data-editor-class="TextEdit" '; ?><?php echo smarty_function_n(array(), $this);?><?php echo 'data-field-name="'; ?><?php echo $this->_tpl_vars['TextEdit']->GetFieldName(); ?><?php echo '" '; ?><?php echo smarty_function_n(array(), $this);?><?php echo 'data-editable="false" '; ?><?php echo smarty_function_n(array(), $this);?><?php echo '>'; ?><?php echo $this->_tpl_vars['TextEdit']->GetValue(); ?><?php echo '</span>'; ?><?php else: ?><?php echo '<span '; ?><?php echo smarty_function_n(array(), $this);?><?php echo 'data-editor="true" '; ?><?php echo smarty_function_n(array(), $this);?><?php echo 'data-editor-class="TextEdit" '; ?><?php echo smarty_function_n(array(), $this);?><?php echo 'data-field-name="'; ?><?php echo $this->_tpl_vars['TextEdit']->GetFieldName(); ?><?php echo '" '; ?><?php echo smarty_function_n(array(), $this);?><?php echo 'data-editable="false" '; ?><?php echo smarty_function_n(array(), $this);?><?php echo '>*************</span>'; ?><?php endif; ?><?php echo ''; ?><?php endif; ?><?php echo ''; ?>