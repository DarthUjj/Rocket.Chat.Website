#!/bin/bash

ssh -t -t root@rocket.chat <<-ENDSSH
	mongo rocketchat <<-ENDMONGO
		db.data.BlogPost.remove({});
		code = 0;
		for (i = 0; i < 15; i++) {
			code++;
			random = "tag " + Math.ceil(Math.random() * 10);
			if (Math.ceil(Math.random() * 10) <= 5) {
				random = "tag " + Math.ceil(Math.random() * 10);
			}
			tags = [ random ];
			db.data.BlogPost.insert({
				_id: new ObjectId().valueOf(),
				"_user": [
					{
						"_id": "52f356ec0cf263faa12db5fa",
						"group": {
							"_id": "52f334dc0cf2b932163f85af",
							"name": "KONECTY"
						},
						"name": "Administrador",
						"active": true
					}
				],
				"status": "Active",
				"slug": "my-slug-" + i,
				"title": "My Slug " + i,
				"body": i + " - body",
				"tags": tags,
				code: code,
				"_createdAt": new Date(1444937765095),
				"_createdBy": {
					"_id": "52f356ec0cf263faa12db5fa",
					"name": "Administrador",
					"group": {
						"_id": "52f334dc0cf2b932163f85af",
						"name": "KONECTY"
					}
				},
				"_updatedAt": new Date(1444937765095),
				"_updatedBy": {
					"_id": "52f356ec0cf263faa12db5fa",
					"name": "Administrador",
					"group": {
						"_id": "52f334dc0cf2b932163f85af",
						"name": "KONECTY"
					}
				}
			})
		}
	ENDMONGO
	exit
ENDSSH
