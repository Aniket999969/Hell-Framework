(function () {

	let MenuTpl =
		'<div id="menu_{{_namespace}}_{{_name}}" class="dialog {{#isBig}}big{{/isBig}}">' +
			'{{#isDefault}}<input type="text" name="value" placeholder="{{title}}" id="inputText"/>{{/isDefault}}' +
				'{{#isBig}}<textarea name="value"/>{{/isBig}}' +
				'<button type="button" name="submit">Accept</button>' +
				'<button type="button" name="cancel">Cancel</button>'
			'</div>' +
		'</div>'
	;

	window.GRPCore_MENU       = {};
	GRPCore_MENU.ResourceName = 'grp-menu-dialog';
	GRPCore_MENU.opened       = {};
	GRPCore_MENU.focus        = [];
	GRPCore_MENU.pos          = {};

	GRPCore_MENU.open = function (namespace, name, data) {

		if (typeof GRPCore_MENU.opened[namespace] == 'undefined') {
			GRPCore_MENU.opened[namespace] = {};
		}

		if (typeof GRPCore_MENU.opened[namespace][name] != 'undefined') {
			GRPCore_MENU.close(namespace, name);
		}

		if (typeof GRPCore_MENU.pos[namespace] == 'undefined') {
			GRPCore_MENU.pos[namespace] = {};
		}

		if (typeof data.type == 'undefined') {
			data.type = 'default';
		}

		if (typeof data.align == 'undefined') {
			data.align = 'top-left';
		}

		data._index = GRPCore_MENU.focus.length;
		data._namespace = namespace;
		data._name = name;

		GRPCore_MENU.opened[namespace][name] = data;
		GRPCore_MENU.pos[namespace][name] = 0;

		GRPCore_MENU.focus.push({
			namespace: namespace,
			name: name
		});

		document.onkeyup = function (key) {
			if (key.which == 27) { // Escape key
				$.post('http://' + GRPCore_MENU.ResourceName + '/menu_cancel', JSON.stringify(data));
			} else if (key.which == 13) { // Enter key
				$.post('http://' + GRPCore_MENU.ResourceName + '/menu_submit', JSON.stringify(data));
			}
		};

		GRPCore_MENU.render();

	};

	GRPCore_MENU.close = function (namespace, name) {

		delete GRPCore_MENU.opened[namespace][name];

		for (let i = 0; i < GRPCore_MENU.focus.length; i++) {
			if (GRPCore_MENU.focus[i].namespace == namespace && GRPCore_MENU.focus[i].name == name) {
				GRPCore_MENU.focus.splice(i, 1);
				break;
			}
		}

		GRPCore_MENU.render();

	};

	GRPCore_MENU.render = function () {

		let menuContainer = $('#menus')[0];

		$(menuContainer).find('button[name="submit"]').unbind('click');
		$(menuContainer).find('button[name="cancel"]').unbind('click');
		$(menuContainer).find('[name="value"]').unbind('input propertychange');

		menuContainer.innerHTML = '';

		$(menuContainer).hide();

		for (let namespace in GRPCore_MENU.opened) {
			for (let name in GRPCore_MENU.opened[namespace]) {

				let menuData = GRPCore_MENU.opened[namespace][name];
				let view = JSON.parse(JSON.stringify(menuData));

				switch (menuData.type) {
					case 'default': {
						view.isDefault = true;
						break;
					}

					case 'big': {
						view.isBig = true;
						break;
					}

					default: break;
				}

				let menu = $(Mustache.render(MenuTpl, view))[0];

				$(menu).css('z-index', 1000 + view._index);

				$(menu).find('button[name="submit"]').click(function () {
					GRPCore_MENU.submit(this.namespace, this.name, this.data);
				}.bind({ namespace: namespace, name: name, data: menuData }));

				$(menu).find('button[name="cancel"]').click(function () {
					GRPCore_MENU.cancel(this.namespace, this.name, this.data);
				}.bind({ namespace: namespace, name: name, data: menuData }));

				$(menu).find('[name="value"]').bind('input propertychange', function () {
					this.data.value = $(menu).find('[name="value"]').val();
					GRPCore_MENU.change(this.namespace, this.name, this.data);
				}.bind({ namespace: namespace, name: name, data: menuData }));

				if (typeof menuData.value != 'undefined')
					$(menu).find('[name="value"]').val(menuData.value);

				menuContainer.appendChild(menu);
			}
		}

		$(menuContainer).show();
		$("#inputText").focus();
	};

	GRPCore_MENU.submit = function (namespace, name, data) {
		$.post('http://' + GRPCore_MENU.ResourceName + '/menu_submit', JSON.stringify(data));
	};

	GRPCore_MENU.cancel = function (namespace, name, data) {
		$.post('http://' + GRPCore_MENU.ResourceName + '/menu_cancel', JSON.stringify(data));
	};

	GRPCore_MENU.change = function (namespace, name, data) {
		$.post('http://' + GRPCore_MENU.ResourceName + '/menu_change', JSON.stringify(data));
	};

	GRPCore_MENU.getFocused = function () {
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
		}

	};

	window.onload = function (e) {
		window.addEventListener('message', (event) => {
			onData(event.data);
		});
	};

})();