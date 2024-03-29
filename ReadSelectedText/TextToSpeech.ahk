#SingleInstance, force
voice := new Voice(5)
global killSwitch := Func("Voice.ForceExitApp").BInd()
return
Media_Next::voice.changeSpeed(1)
Media_Prev::voice.changeSpeed(-1)
Media_Play_Pause::voice.pause()
Esc::voice.exitCheck()
+Space::voice.pause()
#s::voice.readText()
Class Voice {
	__New(speed){
		this.voice :=  ComObjCreate("SAPI.SpVoice")
	}

	exitCheck() {
		if(!this.isSpeaking()) {
			this.voice.Speak("Goodbye")
			ExitApp
		} else {
			this.Pause()
		}
	}
	
	isSpeaking() {
		return this.voice.Status.RunningState != 1
	}

	getSelectedText() {
		saved := ClipboardAll
		Clipboard := ""
		send, ^c
		ClipWait, 0.5
		newClip := Clipboard
		Clipboard := saved
		return newClip
	}

	readText(arg :="") {
		if(!arg) {
			narration := this.getSelectedText()
			if(!narration) {
				this.voice.Speak("No Text Selected",3)
			} else {
				this.voice.Speak(narration,3)
				Loop
				Sleep, 2000
				Until this.voice.Status.RunningState = 1 ; exits when done reading
			}
		}
	}
	
	pause(){
		Status := this.voice.Status.RunningState
		If(Status = 0) { ;if it's paused
			this.voice.Resume
		} Else If(Status = 2) { ;if it's reading
			this.voice.Pause
		}
	}

	changeSpeed(doIncrease) {
		if(doIncrease){
			this.voice.Rate += doIncrease
		} else {
			this.voice.Rate := 0
		}
	}

	ForceExitApp() {
		SetTimer, %killSwitch%, Off
		;~ ExitApp
	}
}
