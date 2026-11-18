black_highway = 0
black_background = 0
no_fail = 0
is_custom_mode = 0

script create_main_menu_elements 
	if NOT ($invite_controller = -1)
		return
	endif
	if ScreenElementExists \{id = current_menu_anchor}
		current_menu_anchor :Die
	endif
	set_focus_color
	set_unfocus_color
	CreateScreenElement \{type = DescInterface
		parent = root_window
		id = current_menu_anchor
		desc = 'menu_frontend'
		just = [
			center
			center
		]}
	if <id> :Desc_ResolveAlias name = alias_menu
		AssignAlias id = <resolved_id> alias = current_menu
		current_menu :SE_SetProps {
			event_handlers = [
				{pad_up generic_menu_up_or_down_sound params = {up}}
				{pad_down generic_menu_up_or_down_sound params = {down}}
			]
			tags = {item_scale = <item_scale>}
			spacing_between = -15
		}
	endif
	add_menu_frontend_item \{desc = 'menu_tape_01'
		text = qs("QUICKPLAY")
		pad_choose_script = main_menu_select_quickplay}
	add_menu_frontend_item \{desc = 'menu_tape_02'
		text = qs("HEAD TO HEAD")
		pad_choose_script = main_menu_select_multiplayer}
	add_menu_frontend_item \{desc = 'menu_tape_03'
	if isXenon
		text = qs("Xbox LIVE")
	else
		text = qs("ONLINE")
	endif
		text = qs("Xbox LIVE")
		pad_choose_script = main_menu_select_online}
	add_menu_frontend_item {
		desc = 'menu_tape_04'
		text = qs("BACKSTAGE")
		pad_choose_script = main_menu_select_backstage
	}
	add_menu_frontend_item \{desc = 'menu_tape_05'
		text = qs("SETTINGS")
		pad_choose_script = main_menu_select_options}
	add_menu_frontend_item \{desc = 'menu_tape_01'
		text = qs("MUSIC STUDIO")
		pad_choose_script = main_menu_select_jam}
	add_menu_frontend_item \{desc = 'menu_tape_02'
		text = qs("MOD MENU")
		pad_choose_script = main_menu_select_downloads}
	show_debug_menus = 0
	if ($enable_button_cheats = 1)
		<show_debug_menus> = 1
		if ($enable_debug_menus = 0)
			<show_debug_menus> = 0
		endif
	endif
	if (<show_debug_menus> = 1)
		add_menu_frontend_item \{text = qs("DEBUG MENU")
			internal_scale = 0.8
			pad_choose_script = main_menu_select_debug}
	endif
	return
	if current_menu_anchor :Desc_ResolveAlias \{name = alias_menu}
		AssignAlias id = <resolved_id> alias = current_menu
		current_menu :SE_SetProps \{event_handlers = [
				{
					pad_up
					generic_menu_up_or_down_sound
					params = {
						up
					}
				}
				{
					pad_down
					generic_menu_up_or_down_sound
					params = {
						down
					}
				}
			]}
		current_menu :obj_spawnscript \{highlight_motion
			no_flip}
		if GetScreenElementChildren \{id = current_menu}
			GetArraySize <children>
			i = 0
			begin
			curr_id = (<children> [<i>])
			<curr_id> :SE_SetProps {
				event_handlers = [
					{focus mainmenu_focus}
					{unfocus mainmenu_unfocus}
				]
				tags = {index = <i>}
			}
			i = (<i> + 1)
			repeat <array_size>
			curr_id = (<children> [0])
			<curr_id> :SE_SetProps {
				text = qs("QUICKPLAY")
				event_handlers = [
					{pad_choose main_menu_select_quickplay}
				]
			}
			curr_id = (<children> [1])
			<curr_id> :SE_SetProps {
				text = qs("HEAD TO HEAD")
				event_handlers = [
					{pad_choose main_menu_select_multiplayer}
				]
			}
			curr_id = (<children> [2])
			<curr_id> :SE_SetProps {
				event_handlers = [
					{pad_choose main_menu_select_online}
				]
			}
			if IsXenon
				<curr_id> :SE_SetProps dims = (0.0, 0.0) text = qs("Xbox LIVE")
			else
				<curr_id> :SE_SetProps dims = (0.0, 0.0) text = qs("ONLINE")
			endif
			curr_id = (<children> [3])
			<curr_id> :SE_SetProps {
				text = qs("BACKSTAGE")
				event_handlers = [
					{pad_choose main_menu_select_backstage}
				]
			}
			curr_id = (<children> [4])
			<curr_id> :SE_SetProps {
				text = qs("OPTIONS")
				event_handlers = [
					{pad_choose main_menu_select_options}
				]
			}
			curr_id = (<children> [5])
			<curr_id> :SE_SetProps {
				text = qs("MUSIC STUDIO")
				event_handlers = [
					{pad_choose main_menu_select_jam}
				]
			}
			curr_id = (<children> [6])
			<curr_id> :SE_SetProps {
				text = qs("MOD MENU")
				event_handlers = [
					{pad_choose main_menu_select_downloads}
				]
			}
			curr_id = (<children> [7])
			<curr_id> :SE_SetProps {
				event_handlers = [
					{pad_choose main_menu_select_debug}
				]
			}
			show_debug_menus = 0
			if ($enable_button_cheats = 1)
				<show_debug_menus> = 1
				if ($enable_debug_menus = 0)
					<show_debug_menus> = 0
				endif
			endif
			if (<show_debug_menus> = 0)
				<curr_id> :Die
			endif
		endif
	endif
endscript

script ui_create_downloads
	change \{respond_to_signin_changed = 1}
	change \{respond_to_signin_changed_func = none}
	menu_music_on
	create_frontend_bg
	make_menu_frontend \{screen = bassist
		title = qs("MOD MENU") desc = 'menu_tape_01'}
	add_menu_frontend_item \{text = qs("Modifiers")
		choose_state = uistate_atom_unlock desc = 'menu_tape_02'}	
	add_menu_frontend_item \{text = qs("Unlock All")
		pad_choose_script = playday_unlockall desc = 'menu_tape_03'}
	add_menu_frontend_item \{text = qs("Show FPS")
		pad_choose_script = ToggleFPS desc = 'menu_tape_04'}
	<desc_id> :Obj_SpawnScriptNow career_menu_jaw_anim
	menu_finish
endscript

script ui_create_atom_unlock 
	make_generic_menu \{title = qs("Modifiers")}
	add_generic_menu_text_item \{text = qs("No Fail")
		pad_choose_script = ui_no_fail_toggle}
	add_generic_menu_text_item \{text = qs("Black Background")
		pad_choose_script = ui_black_background_toggle}
	add_generic_menu_text_item \{text = qs("Use Pad as Instrument")
		pad_choose_script = toggle_allowcontroller}
	add_generic_menu_text_item \{text = qs("Debug Mode")
		pad_choose_script = ui_debug_mode_toggle}
	menu_finish
endscript

script ui_no_fail_toggle
	if ($no_fail = 0)
		Change no_fail = 1
		change \{debug_forcescore = good}
		SoundEvent \{Event = CheckBox_Check_SFX}
	else
		Change no_fail = 0
		change \{debug_forcescore = off}
		SoundEvent \{Event = CheckBox_SFX}
	endif
endscript

script ui_black_highway_toggle
	if ($black_highway = 0)
		Change black_highway = 1
		Change highway_normal = [0 0 0 255]
		Change highway_starpower = [0 0 0 255]
	 	SoundEvent \{Event = CheckBox_Check_SFX}
	else
		Change black_highway = 0
		Change highway_normal = [255 255 255 255]
		Change highway_starpower = [64 255 255 255]
		SoundEvent \{Event = CheckBox_SFX}
	endif
endscript

script ui_debug_mode_toggle
	if ($enable_button_cheats = 0)
		Change enable_button_cheats = 1
		change \{enable_debug_menus = 1}
		SoundEvent \{Event = CheckBox_Check_SFX}
	else
		Change enable_button_cheats = 0
		change \{enable_debug_menus = 0}
		SoundEvent \{Event = CheckBox_SFX}
	endif
endscript

script ui_black_background_toggle
	if ($black_background = 0)
		Change black_background = 1
		SoundEvent \{Event = CheckBox_Check_SFX}
	else
		Change black_background = 0
		SoundEvent \{Event = CheckBox_SFX}
	endif
endscript

script toggle_allowcontroller 
	if ($allow_controller_for_all_instruments = 1)
		change \{allow_controller_for_all_instruments = 0}
		SoundEvent \{Event = CheckBox_SFX}
	else
		change \{allow_controller_for_all_instruments = 1}
		SoundEvent \{Event = CheckBox_Check_SFX}
	endif
	toggle_allowcontroller_setprop
endscript