(() => {

	let GRPCoreWrapper = {};
	GRPCoreWrapper.MessageSize = 1024;
	GRPCoreWrapper.messageId = 0;

	window.SendMessage = function (namespace, type, msg) {

		GRPCoreWrapper.messageId = (GRPCoreWrapper.messageId < 65535) ? GRPCoreWrapper.messageId + 1 : 0;
		const str = JSON.stringify(msg);

		for (let i = 0; i < str.length; i++) {

			let count = 0;
			let chunk = '';

			while (count < GRPCoreWrapper.MessageSize && i < str.length) {

				chunk += str[i];

				count++;
				i++;
			}

			i--;

			const data = {
				__type: type,
				id: GRPCoreWrapper.messageId,
				chunk: chunk
			}

			if (i == str.length - 1)
				data.end = true;

			$.post('http://' + namespace + '/__chunk', JSON.stringify(data));

		}

	}

})()
