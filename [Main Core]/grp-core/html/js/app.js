(() => {

	GRPCore = {};
	GRPCore.HUDElements = [];

	GRPCore.setHUDDisplay = function (opacity) {
		$('#hud').css('opacity', opacity);
	};

	GRPCore.insertHUDElement = function (name, index, priority, html, data) {
		GRPCore.HUDElements.push({
			name: name,
			index: index,
			priority: priority,
			html: html,
			data: data
		});

		GRPCore.HUDElements.sort((a, b) => {
			return a.index - b.index || b.priority - a.priority;
		});
	};

	GRPCore.updateHUDElement = function (name, data) {

		for (let i = 0; i < GRPCore.HUDElements.length; i++) {
			if (GRPCore.HUDElements[i].name == name) {
				GRPCore.HUDElements[i].data = data;
			}
		}

		GRPCore.refreshHUD();
	};

	GRPCore.deleteHUDElement = function (name) {
		for (let i = 0; i < GRPCore.HUDElements.length; i++) {
			if (GRPCore.HUDElements[i].name == name) {
				GRPCore.HUDElements.splice(i, 1);
			}
		}

		GRPCore.refreshHUD();
	};

	GRPCore.refreshHUD = function () {
		$('#hud').html('');

		for (let i = 0; i < GRPCore.HUDElements.length; i++) {
			let html = Mustache.render(GRPCore.HUDElements[i].html, GRPCore.HUDElements[i].data);
			$('#hud').append(html);
		}
	};

	GRPCore.inventoryNotification = function (add, item, count) {
		let notif = '';

		if (add) {
			notif += '+';
		} else {
			notif += '-';
		}

		notif += count + ' ' + item.label;

		let elem = $('<div>' + notif + '</div>');

		$('#inventory_notifications').append(elem);

		$(elem).delay(3000).fadeOut(1000, function () {
			elem.remove();
		});
	};

	window.onData = (data) => {
		switch (data.action) {
			case 'setHUDDisplay': {
				GRPCore.setHUDDisplay(data.opacity);
				break;
			}

			case 'insertHUDElement': {
				GRPCore.insertHUDElement(data.name, data.index, data.priority, data.html, data.data);
				break;
			}

			case 'updateHUDElement': {
				GRPCore.updateHUDElement(data.name, data.data);
				break;
			}

			case 'deleteHUDElement': {
				GRPCore.deleteHUDElement(data.name);
				break;
			}

			case 'inventoryNotification': {
				GRPCore.inventoryNotification(data.add, data.item, data.count);
			}
		}
	};

	window.onload = function (e) {
		window.addEventListener('message', (event) => {
			onData(event.data);
		});
	};

})();