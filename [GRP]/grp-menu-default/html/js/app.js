(function(){

	let MenuTpl =
		'<div id="menu_{{_namespace}}_{{_name}}" class="menu{{#align}} align-{{align}}{{/align}}">' +
			'<div class="head"><span>{{{title}}}</span></div>' +
				'<div class="menu-items">' + 
					'{{#elements}}' +
						'<div class="menu-item {{#selected}}selected{{/selected}}">' +
							'{{{label}}}{{#isSlider}} : &lt;{{{sliderLabel}}}&gt;{{/isSlider}}' +
						'</div>' +
					'{{/elements}}' +
				'</div>'+
			'</div>' +
		'</div>'
	;

	window.GRPCore_MENU       = {};
	GRPCore_MENU.ResourceName = 'grp-menu-default';
	GRPCore_MENU.opened       = {};
	GRPCore_MENU.focus        = [];
	GRPCore_MENU.pos          = {};

	GRPCore_MENU.open = function(namespace, name, data) {

		if (typeof GRPCore_MENU.opened[namespace] == 'undefined') {
			GRPCore_MENU.opened[namespace] = {};
		}

		if (typeof GRPCore_MENU.opened[namespace][name] != 'undefined') {
			GRPCore_MENU.close(namespace, name);
		}

		if (typeof GRPCore_MENU.pos[namespace] == 'undefined') {
			GRPCore_MENU.pos[namespace] = {};
		}

		for (let i=0; i<data.elements.length; i++) {
			if (typeof data.elements[i].type == 'undefined') {
				data.elements[i].type = 'default';
			}
		}

		data._index     = GRPCore_MENU.focus.length;
		data._namespace = namespace;
		data._name      = name;

		for (let i=0; i<data.elements.length; i++) {
			data.elements[i]._namespace = namespace;
			data.elements[i]._name      = name;
		}

		GRPCore_MENU.opened[namespace][name] = data;
		GRPCore_MENU.pos   [namespace][name] = 0;

		for (let i=0; i<data.elements.length; i++) {
			if (data.elements[i].selected) {
				GRPCore_MENU.pos[namespace][name] = i;
			} else {
				data.elements[i].selected = false;
			}
		}

		GRPCore_MENU.focus.push({
			namespace: namespace,
			name     : name
		});
		
		GRPCore_MENU.render();
		$('#menu_' + namespace + '_' + name).find('.menu-item.selected')[0].scrollIntoView();
	};

	GRPCore_MENU.close = function(namespace, name) {
		
		delete GRPCore_MENU.opened[namespace][name];

		for (let i=0; i<GRPCore_MENU.focus.length; i++) {
			if (GRPCore_MENU.focus[i].namespace == namespace && GRPCore_MENU.focus[i].name == name) {
				GRPCore_MENU.focus.splice(i, 1);
				break;
			}
		}

		GRPCore_MENU.render();

	};

	GRPCore_MENU.render = function() {

		let menuContainer       = document.getElementById('menus');
		let focused             = GRPCore_MENU.getFocused();
		menuContainer.innerHTML = '';

		$(menuContainer).hide();

		for (let namespace in GRPCore_MENU.opened) {
			for (let name in GRPCore_MENU.opened[namespace]) {

				let menuData = GRPCore_MENU.opened[namespace][name];
				let view     = JSON.parse(JSON.stringify(menuData));

				for (let i=0; i<menuData.elements.length; i++) {
					let element = view.elements[i];

					switch (element.type) {
						case 'default' : break;

						case 'slider' : {
							element.isSlider    = true;
							element.sliderLabel = (typeof element.options == 'undefined') ? element.value : element.options[element.value];

							break;
						}

						default : break;
					}

					if (i == GRPCore_MENU.pos[namespace][name]) {
						element.selected = true;
					}
				}

				let menu = $(Mustache.render(MenuTpl, view))[0];
				$(menu).hide();
				menuContainer.appendChild(menu);
			}
		}

		if (typeof focused != 'undefined') {
			$('#menu_' + focused.namespace + '_' + focused.name).show();
		}

		$(menuContainer).show();

	};

	GRPCore_MENU.submit = function(namespace, name, data) {
		$.post('http://' + GRPCore_MENU.ResourceName + '/menu_submit', JSON.stringify({
			_namespace: namespace,
			_name     : name,
			current   : data,
			elements  : GRPCore_MENU.opened[namespace][name].elements
		}));
	};

	GRPCore_MENU.cancel = function(namespace, name) {
		$.post('http://' + GRPCore_MENU.ResourceName + '/menu_cancel', JSON.stringify({
			_namespace: namespace,
			_name     : name
		}));
	};

	GRPCore_MENU.change = function(namespace, name, data) {
		$.post('http://' + GRPCore_MENU.ResourceName + '/menu_change', JSON.stringify({
			_namespace: namespace,
			_name     : name,
			current   : data,
			elements  : GRPCore_MENU.opened[namespace][name].elements
		}));
	};

	GRPCore_MENU.getFocused = function() {
		return GRPCore_MENU.focus[GRPCore_MENU.focus.length - 1];
	};

	window.onData = (data) => {

		switch (data.action) {

			case 'openMenu': {
				GRPCore_MENU.open(data.namespace, data.name, data.data);
				break;
			}

			case 'closeMenu': {
				GRPCore_MENU.close(data.namespace, data.name);
				break;
			}

			case 'controlPressed': {

				switch (data.control) {

					case 'ENTER': {
						let focused = GRPCore_MENU.getFocused();

						if (typeof focused != 'undefined') {
							let menu    = GRPCore_MENU.opened[focused.namespace][focused.name];
							let pos     = GRPCore_MENU.pos[focused.namespace][focused.name];
							let elem    = menu.elements[pos];

							if (menu.elements.length > 0) {
								GRPCore_MENU.submit(focused.namespace, focused.name, elem);
							}
						}

						break;
					}

					case 'BACKSPACE': {
						let focused = GRPCore_MENU.getFocused();

						if (typeof focused != 'undefined') {
							GRPCore_MENU.cancel(focused.namespace, focused.name);
						}

						break;
					}

					case 'TOP': {

						let focused = GRPCore_MENU.getFocused();

						if (typeof focused != 'undefined') {

							let menu = GRPCore_MENU.opened[focused.namespace][focused.name];
							let pos  = GRPCore_MENU.pos[focused.namespace][focused.name];

							if (pos > 0) {
								GRPCore_MENU.pos[focused.namespace][focused.name]--;
							} else {
								GRPCore_MENU.pos[focused.namespace][focused.name] = menu.elements.length - 1;
							}

							let elem = menu.elements[GRPCore_MENU.pos[focused.namespace][focused.name]];

							for (let i=0; i<menu.elements.length; i++) {
								if (i == GRPCore_MENU.pos[focused.namespace][focused.name]) {
									menu.elements[i].selected = true;
								} else {
									menu.elements[i].selected = false;
								}
							}

							GRPCore_MENU.change(focused.namespace, focused.name, elem);
							GRPCore_MENU.render();

							$('#menu_' + focused.namespace + '_' + focused.name).find('.menu-item.selected')[0].scrollIntoView();
						}

						break;

					}

					case 'DOWN' : {

						let focused = GRPCore_MENU.getFocused();

						if (typeof focused != 'undefined') {
							let menu   = GRPCore_MENU.opened[focused.namespace][focused.name];
							let pos    = GRPCore_MENU.pos[focused.namespace][focused.name];
							let length = menu.elements.length;

							if (pos < length - 1) {
								GRPCore_MENU.pos[focused.namespace][focused.name]++;
							} else {
								GRPCore_MENU.pos[focused.namespace][focused.name] = 0;
							}

							let elem = menu.elements[GRPCore_MENU.pos[focused.namespace][focused.name]];

							for (let i=0; i<menu.elements.length; i++) {
								if (i == GRPCore_MENU.pos[focused.namespace][focused.name]) {
									menu.elements[i].selected = true;
								} else {
									menu.elements[i].selected = false;
								}
							}

							GRPCore_MENU.change(focused.namespace, focused.name, elem);
							GRPCore_MENU.render();

							$('#menu_' + focused.namespace + '_' + focused.name).find('.menu-item.selected')[0].scrollIntoView();
						}

						break;
					}

					case 'LEFT' : {

						let focused = GRPCore_MENU.getFocused();

						if (typeof focused != 'undefined') {
							let menu = GRPCore_MENU.opened[focused.namespace][focused.name];
							let pos  = GRPCore_MENU.pos[focused.namespace][focused.name];
							let elem = menu.elements[pos];

							switch(elem.type) {
								case 'default': break;

								case 'slider': {
									let min = (typeof elem.min == 'undefined') ? 0 : elem.min;

									if (elem.value > min) {
										elem.value--;
										GRPCore_MENU.change(focused.namespace, focused.name, elem);
									}

									GRPCore_MENU.render();
									break;
								}

								default: break;
							}

							$('#menu_' + focused.namespace + '_' + focused.name).find('.menu-item.selected')[0].scrollIntoView();
						}

						break;
					}

					case 'RIGHT' : {

						let focused = GRPCore_MENU.getFocused();

						if (typeof focused != 'undefined') {
							let menu = GRPCore_MENU.opened[focused.namespace][focused.name];
							let pos  = GRPCore_MENU.pos[focused.namespace][focused.name];
							let elem = menu.elements[pos];

							switch(elem.type) {
								case 'default': break;

								case 'slider': {
									if (typeof elem.options != 'undefined' && elem.value < elem.options.length - 1) {
										elem.value++;
										GRPCore_MENU.change(focused.namespace, focused.name, elem);
									}

									if (typeof elem.max != 'undefined' && elem.value < elem.max) {
										elem.value++;
										GRPCore_MENU.change(focused.namespace, focused.name, elem);
									}

									GRPCore_MENU.render();
									break;
								}

								default: break;
							}

							$('#menu_' + focused.namespace + '_' + focused.name).find('.menu-item.selected')[0].scrollIntoView();
						}

						break;
					}

					default : break;

				}

				break;
			}

		}

	};

	window.onload = function(e){
		window.addEventListener('message', (event) => {
			onData(event.data);
		});
	};

})();