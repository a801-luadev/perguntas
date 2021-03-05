local texts = {
	en = {
		title = "Questions",
		displayAnswer = "The answer for the question was <B>%s</B>.",
		choosing = "Choosing Shaman...",
		welcome = "<J>Welcome to the Questions module! Type !help to learn more.\n<ROSE>Official thread on forums: <BV><B>https://atelier801.com/topic?f=6&t=893377</B>",
		introShaman = "<J>You're the shaman! Type <B>!q</B> to ask",
		newShaman = "<CEP>%s is the one asking now",
		help = "<CEP>The module consists in a Shaman that is going to ask questions for the other players - these that have to answer. The first player getting 5 correct answers for the questions wins the game and becomes the next Shaman.\n\nType <B>!q</B> to make a question when it is your Shaman turn.",
		helpAdmin = "<R>Room Admin commands:\n• <B>!skip</B> - Chooses another shaman to make the questions\n• <B>!players</B> - Toggles the ban system of the module. If enabled, players will be able to use <B>!skip</B> to vote to skip the current shaman.\n• <B>!next</B> <V>[player name]</V> - Chooses the next shaman.\n• <B>!pw</B> <V>[password]</V> - Sets a password to the room.",
		helpSkip = "Type <B>!skip</B> to vote to skip the turn of the current shaman.",
		enterQuestion = "Type your question",
		skipFromShaman = "<R>%s skipped their turn.",
		skipAttemptDisabled = "<R>The command <B>!skip</B> is disabled.",
		skipShaman = "<R>%s's turn has been skipped.",
		skipEnabled = "• <B>!skip</B> enabled",
		skipDisabled = "• <B>!skip</B> disabled",
		seeQuestion = "Your question: %s",
		enterAnswer = "Type the answer of the question",
		seeAnswer = "The answer for your question: %s",
		win = "<VP>%s got it right!"
	},
	br = {
		title = "Perguntas",
		displayAnswer = "A resposta da pergunta era <B>%s</B>.",
		choosing = "Escolhendo Shaman...",
		welcome = "<J>Bem vindo ao module Perguntas! Digite !help para mais informações.\n<ROSE>Tópico oficial no fórum: <BV><B>https://atelier801.com/topic?f=6&t=893374</B>",
		introShaman = "<J>Você é o shaman! Digite <B>!q</B> para fazer a pergunta",
		newShaman = "<CEP>%s estará fazendo as perguntas agora",
		help = "<CEP>O minigame consiste em um Shaman que irá realizar perguntas para os demais jogadores responder. O primeiro jogador a acertar 5 perguntas ganha o jogo e se torna o próximo Shaman.\n\nDigite <B>!q</B> para fazer uma pergunta quando for sua vez de ser o Shaman.",
		helpAdmin = "<R>Comandos de Room Admin:\n• <B>!skip</B> - Escolhe outro shaman para fazer as perguntas\n• <B>!players</B> - Ativa ou desativa o sistema de ban do módulo. Se ativado, os jogadores irão poder votar para pular o shaman atual.\n• <B>!next</B> <V>[nome do jogador]</V> - Escolhe o próximo shaman.\n• <B>!pw</B> <V>[senha]</V> - Define uma senha para a sala.",
		helpSkip = "Digite <B>!skip</B> para votar para pular a vez do shaman atual.",
		enterQuestion = "Digite sua pergunta",
		skipFromShaman = "<R>%s pulou sua vez.",
		skipAttemptDisabled = "<R>O comando <B>!skip</B> está desativado.",
		skipShaman = "<R>%s teve sua vez pulada.",
		skipEnabled = "• <B>!skip</B> ativado",
		skipDisabled = "• <B>!skip</B> desativado",
		seeQuestion = "Sua pergunta: %s",
		enterAnswer = "Digite a resposta da sua pergunta",
		seeAnswer = "A resposta para sua pergunta: %s",
		win = "<VP>%s acertou!"
	},
	es = {
		title = "Preguntas",
		displayAnswer = "La respuesta a la pregunta era <B>%s</B>.",
		choosing = "Eligiendo el Chamán...",
		welcome = "<J>Bienvenido al module Preguntas! Escribe !help para más información.\n<ROSE>Hilo oficial: <BV><B>https://atelier801.com/topic?f=6&t=893375</B>",
		introShaman = "<J>Eres el Chamán! Escribe <B>!q</B> para hacer la pregunta",
		newShaman = "<CEP>%s hará las preguntas ahora",
		help = "<CEP>El minijuego consiste en un Chamán que hará preguntas para que otros jugadores respondan. El primer jugador en acertar 5 preguntas gana el juego y se convierte en el próximo chamán.\n\nEscribe <B>!q</B> para hacer una pregunta cuando sea su turno como chamán.",
		helpAdmin = "<R>Room Admin commands:\n• <B>!skip</B> - Chooses another shaman to make the questions\n• <B>!players</B> - Toggles the ban system of the module. If enabled, players will be able to use <B>!skip</B> to vote to skip the current shaman.\n• <B>!next</B> <V>[player name]</V> - Chooses the next shaman.\n• <B>!pw</B> <V>[password]</V> - Sets a password to the room.",
		helpSkip = "Type <B>!skip</B> to vote to skip the turn of the current shaman.",
		enterQuestion = "Escriba su pregunta",
		skipFromShaman = "<R>%s saltó su turno",
		skipAttemptDisabled = "<R>The command <B>!skip</B> is disabled.",
		skipShaman = "<R>%s's turn has been skipped.",
		skipEnabled = "• <B>!skip</B> enabled",
		skipDisabled = "• <B>!skip</B> disabled",
		seeQuestion = "Su pregunta: %s",
		enterAnswer = "Escribe la respuesta para su pregunta",
		seeAnswer = "La respuesta para su pregunta: %s",
		win = "<VP>%s obtuvo la respuesta correcta!"
	}
}
local translation = tfm.get.room.community
translation = texts[translation] or texts.en

string.nickname = function(str)
	return (str:lower():gsub('%a', string.upper, 1))
end

local roomAdmins = {
	["Bolodefchoco#0015"] = true
}
for name in tfm.get.room.name:gmatch("[%+%w][%w_][%w_]+#%d%d%d%d") do
	roomAdmins[string.nickname(name)] = true
end

local initModuleTimer = 1000

local playerData = { }

local stageNames = { "I", "II", "III", "IV", "V" }
local totalStages = #stageNames

local chooseShaman = true
local newShaman, nextShaman
local currentQuestion, currentAnswer
local skip = 0
local hasSkipped = { }
local canSkip = false

local removeAccents
do
	local letters = {
		{ 'á', 'a' },
		{ 'à', 'a' },
		{ 'â', 'a' },
		{ 'ä', 'a' },
		{ 'ã', 'a' },
		{ 'å', 'a' },
		{ 'é', 'e' },
		{ 'è', 'e' },
		{ 'ê', 'e' },
		{ 'ë', 'e' },
		{ 'í', 'i' },
		{ 'ì', 'i' },
		{ 'î', 'i' },
		{ 'ï', 'i' },
		{ 'ó', 'o' },
		{ 'ò', 'o' },
		{ 'ô', 'o' },
		{ 'ö', 'o' },
		{ 'õ', 'o' },
		{ 'ú', 'u' },
		{ 'ù', 'u' },
		{ 'û', 'u' },
		{ 'ü', 'u' },
		{ 'ç', 'c' },
		{ 'ñ', 'n' },
		{ 'ý', 'y' },
		{ 'ÿ', 'y' }
	}
	--[[Doc
		"Removes the accents in the string"
		@str string
		>stirng
	]]
	removeAccents = function(str)
		for s = 1, 2 do
			local f = (s == 1 and string.lower or string.upper)
			for i = 1, #letters do
				i = letters[i]
				str = string.gsub(str, f(i[1]), f(i[2]))
			end
		end
		return str
	end
end

string.trim = function(str)
	return (string.gsub(tostring(str), "^ *(.*) *$", "%1"))
end

table.random = function(tbl)
	return tbl[math.random(#tbl)]
end

local displayStageNames = function(playerName)
	for i = 1, totalStages do
		ui.addTextArea(i, "<p align='center'><font size='30' color='#000000'><B>" .. stageNames[i], playerName, 390 + (i - 1) * 200, 180, 200, nil, 1, 1, 0, false)
	end

	ui.setMapName(translation.title)
	if newShaman then
		ui.setShamanName(newShaman)
	end
end

do
	local setPlayerScore = tfm.exec.setPlayerScore
	tfm.exec.setPlayerScore = function(playerName, score, add)
		playerData[playerName].score = (add and (playerData[playerName].score + score) or score)
		setPlayerScore(playerName, score, add)
	end
end

local setPlayerData = function(playerName)
	playerData[playerName] = {
		currentStage = 0,
		score = 0,
		isInRoom = true
	}

	tfm.exec.setPlayerScore(playerName, 0)
end

local getNewShaman = function()
	if nextShaman and playerData[nextShaman] and playerData[nextShaman].isInRoom then
		return nextShaman
	end

	local scores, counter = { }, 0
	local hasMoreThanZeroPoints = false

	local score
	for playerName, data in next, playerData do
		if data.isInRoom and string.sub(playerName, -5, -5) == '#' then -- Not souris
			counter = counter + 1
			scores[counter] = {
				playerName = playerName,
				score = data.score
			}

			if data.score > 0 then
				hasMoreThanZeroPoints = true
			end
		end
	end

	if hasMoreThanZeroPoints then
		table.sort(scores, function(p1, p2)
			return p1.score > p2.score
		end)

		return scores[1].playerName
	elseif counter > 0 then
		return scores[math.random(counter)].playerName
	end
end

local resetAllPlayerData = function()
	local gc, counter = { }, 0

	for playerName, data in next, playerData do
		data.currentStage = 0
		tfm.exec.setPlayerScore(playerName, 0)
		if not data.isInRoom then
			counter = counter + 1
			gc[counter] = playerName
		end
	end

	for player = 1, counter do
		playerData[gc[player]] = nil
	end
end

local movePlayerToStage = function(playerName)
	tfm.exec.movePlayer(playerName, 300 + playerData[playerName].currentStage * 200, 365)
end

local moveAllToSpawnPoint = function()
	for playerName in next, tfm.get.room.playerList do
		tfm.exec.movePlayer(playerName, 125, 365)
	end
end

local displayAnswer = function()
	if not currentAnswer then return end
	tfm.exec.chatMessage(string.format(translation.displayAnswer, currentAnswer))
end

local startChooseFlow = function(ignoreAnswer)
	if newShaman then
		tfm.exec.respawnPlayer(newShaman)
		newShaman = nil
	end
	if not ignoreAnswer then
		displayAnswer()
	end

	currentQuestion = nil
	currentAnswer = nil
	skip = 0
	hasSkipped = { }
	chooseShaman = true

	moveAllToSpawnPoint()

	ui.removeTextArea(0)
	tfm.exec.setGameTime(5)
	tfm.exec.chatMessage(translation.choosing)
end

local displayQuestion = function(playerName)
	if not currentAnswer then return end
	ui.addTextArea(0, "<p align='center'><font size='20'>" .. currentQuestion, playerName, 5, 50, 400, nil, nil, nil, .75, true)
end

eventNewPlayer = function(playerName)
	tfm.exec.respawnPlayer(playerName)
	if chooseShaman or not playerData[playerName] then
		setPlayerData(playerName)
	else
		playerData[playerName].isInRoom = true
		if playerData[playerName].currentStage > 0 then
			movePlayerToStage(playerName)
			tfm.exec.setPlayerScore(playerName, playerData[playerName].score)
		end
	end

	displayQuestion(playerName)
	displayStageNames(playerName)
	tfm.exec.chatMessage(translation.welcome, playerName)

	if roomAdmins[playerName] then
		tfm.exec.chatMessage("• ROOM ADMIN: <V><B>" .. playerName .. "</B>", playerName)
	end
end

eventNewGame = function()
	for playerName in next, tfm.get.room.playerList do
		setPlayerData(playerName)
	end
	displayStageNames()

	startChooseFlow()
end

eventLoop = function(currentTime, remainingTime)
	if initModuleTimer > 0 then
		initModuleTimer = initModuleTimer - 500
		return
	end

	if chooseShaman then
		if remainingTime > 0 then return end
		chooseShaman = false

		newShaman = getNewShaman()
		nextShaman = nil
		resetAllPlayerData()

		tfm.exec.setShaman(newShaman)
		tfm.exec.killPlayer(newShaman)
		tfm.exec.chatMessage(translation.introShaman, newShaman)

		ui.setShamanName(newShaman)
		tfm.exec.chatMessage(string.format(translation.newShaman, newShaman))

		tfm.exec.setGameTime(60)
	else
		if remainingTime <= 0 then
			startChooseFlow()
		end
	end
end

eventChatCommand = function(playerName, command)
	local isAdmin = roomAdmins[playerName]
	local isShaman = playerName == newShaman

	if command == "help" then
		tfm.exec.chatMessage(translation.help .. (canSkip and ("\n\n" .. translation.helpSkip) or ''), playerName)
		if isAdmin then
			tfm.exec.chatMessage(translation.helpAdmin, playerName)
		end
		return
	end

	if chooseShaman then return end

	if command == "skip" then
		if isShaman then
			tfm.exec.chatMessage(string.format(translation.skipFromShaman, playerName))
			startChooseFlow()
			return
		end

		if not canSkip and not isAdmin then
			tfm.exec.chatMessage(translation.skipAttemptDisabled, playerName)
			return
		end

		if hasSkipped[playerName] then return end
		hasSkipped[playerName] = true

		local half = math.ceil(tfm.get.room.uniquePlayers / 2)

		skip = skip + 1
		if isAdmin or skip >= half then
			tfm.exec.chatMessage(string.format(translation.skipShaman, newShaman))
			startChooseFlow()
		else
			tfm.exec.chatMessage("• o/", playerName)
		end
	end

	if isShaman then
		if command == 'q' then
			ui.addPopup(0, 2, translation.enterQuestion, newShaman, 200, 170, 400, true)
		end
	end

	if roomAdmins[playerName] then
		if command == "players" then
			canSkip = not canSkip

			skip = 0
			hasSkipped = { }

			if canSkip then
				tfm.exec.chatMessage(translation.skipEnabled)
			else
				tfm.exec.chatMessage(translation.skipDisabled)
			end
		elseif command:sub(1, 5) == "next " then
			local name = string.nickname(command:sub(6))
			if tfm.get.room.playerList[name] then
				nextShaman = name
				tfm.exec.chatMessage("• NEXT: <V><B>" .. name .. "</B>")
			end
		elseif command:sub(1, 2) == "pw" then
			local pw = command:sub(4)
			tfm.exec.setRoomPassword(pw)
			if pw ~= '' then
				tfm.exec.chatMessage("• PW <R>OK</R>!", playerName)
			else
				tfm.exec.chatMessage("• PW <R>X</R>!", playerName)
			end
		end
	end
end

eventPopupAnswer = function(id, playerName, answer)
	if chooseShaman then return end
	if playerName ~= newShaman then return end

	answer = string.trim(answer)
	if answer == '' then return end
	answer = answer:gsub('<', "&lt;"):gsub('>', "&gt;")

	if id == 0 then -- Pergunta
		currentAnswer = nil
		currentQuestion = answer

		tfm.exec.chatMessage(string.format(translation.seeQuestion, answer), playerName)
		ui.addPopup(1, 2, translation.enterAnswer, playerName, 200, 170, 400, true)
	elseif id == 1 then -- Resposta
		currentAnswer = removeAccents(string.lower(answer))

		displayQuestion()
		tfm.exec.setGameTime(60)

		tfm.exec.chatMessage(string.format(translation.seeAnswer, currentAnswer), playerName)
	end
end

eventChatMessage = function(playerName, message)
	if chooseShaman then return end
	if removeAccents(string.lower(message)) ~= currentAnswer then return end
	if playerName == newShaman then
		return startChooseFlow()
	end
	tfm.exec.chatMessage(string.format(translation.win, playerName))
	displayAnswer()

	currentAnswer = nil

	playerData[playerName].currentStage = playerData[playerName].currentStage + 1
	movePlayerToStage(playerName)

	tfm.exec.setPlayerScore(playerName, 1, true)

	if playerData[playerName].currentStage == totalStages then
		if not nextShaman then
			nextShaman = playerName
		end
		startChooseFlow(true)
	else
		tfm.exec.setGameTime(60)
		ui.removeTextArea(0)
	end
end

eventPlayerLeft = function(playerName)
	playerData[playerName].isInRoom = false

	if chooseShaman then return end
	if playerName ~= newShaman and playerName ~= nextShaman then return end

	startChooseFlow()
end

eventPlayerRespawn = function(playerName)
	tfm.exec.setShaman(playerName, false)
end

tfm.exec.disableAutoNewGame()
tfm.exec.disableAutoShaman()
tfm.exec.disableAfkDeath()
tfm.exec.disableMortCommand()
tfm.exec.disableAutoScore()
tfm.exec.disablePhysicalConsumables()
tfm.exec.disableAllShamanSkills()

system.disableChatCommandDisplay()

local xml = '<C><P DS="m;45,365,65,365,85,365,105,365,125,365,145,365,165,365,185,365,205,365,225,365,245,365,265,365,285,365,305,365,325,365,345,365" L="1400" /><Z><S><S L="400" H="20" X="1390" Y="200" T="10" P=",,.3,,270,,," /><S L="400" X="10" H="20" Y="200" T="10" P=",,.3,,90,,," /><S L="400" X="390" H="20" Y="200" T="10" P=",,.3,,270,,," /><S L="400" H="20" X="400" Y="200" T="10" P=",,.3,,90,,," /><S L="400" H="20" X="590" Y="200" T="10" P=",,.3,,270,,," /><S L="400" X="790" H="20" Y="200" T="10" P=",,.3,,270,,," /><S L="400" H="20" X="990" Y="200" T="10" P=",,.3,,270,,," /><S L="400" X="1190" H="20" Y="200" T="10" P=",,.3,,270,,," /><S L="400" X="600" H="20" Y="200" T="10" P=",,.3,,90,,," /><S L="400" H="20" X="800" Y="200" T="10" P=",,.3,,90,,," /><S L="400" X="1000" H="20" Y="200" T="10" P=",,.3,,90,,," /><S L="400" H="20" X="1200" Y="200" T="10" P=",,.3,,90,,," /><S L="1400" X="700" H="20" Y="10" T="10" P=",,.3,,180,,," /><S L="1400" H="20" X="700" Y="390" T="10" P=",,.3,,,,," /></S><D /><O /></Z></C>'
local groundId = table.random({ 6, 17, 11, 10 })
xml = string.gsub(xml, "T=\"10\"", "T=\"" .. groundId .. "\"")
tfm.exec.newGame(xml)
