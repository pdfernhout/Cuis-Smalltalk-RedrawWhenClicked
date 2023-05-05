'From Cuis 6.0 [latest update: #5772] on 4 May 2023 at 9:48:46 pm'!
!classDefinition: #KfMithrilInspiredExperimentMorph category: 'KfExperiments'!
BoxedMorph subclass: #KfMithrilInspiredExperimentMorph
	instanceVariableNames: 'temperatureF temperatureC'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'KfExperiments'!
!KfMithrilInspiredExperimentMorph commentStamp: 'pdfernhout 5/4/2023 21:16:14' prior: 0!
"KfMithrilInspiredExperimentMorph new openInWorld"!


!KfMithrilInspiredExperimentMorph methodsFor: 'as yet unclassified' stamp: 'pdfernhout 5/4/2023 20:58:49'!
convert

	temperatureC :=  ((temperatureF - 32 ) / 9 * 5) asFloat rounded.
	
	"self redrawNeeded."! !

!KfMithrilInspiredExperimentMorph methodsFor: 'as yet unclassified' stamp: 'pdfernhout 5/4/2023 21:37:12'!
drawOn: aCanvas

	| cColor |

	super drawOn: aCanvas.
	
	aCanvas drawString: 'Mithril-inspired Fahrenheight to Celcius Converter' at: 20 @ 20 font: nil color: Color orange.
	
	aCanvas drawString: 'F: ' , temperatureF asString at: 20 @ 60 font: nil color: Color orange.
	
	aCanvas drawString: 'CONVERT' at: 20 @ 100 font: nil color: Color gray.
	
	cColor := 	((temperatureC = ((temperatureF - 32 ) / 9 * 5) asFloat rounded) 
		ifTrue: [Color green]
		ifFalse: [Color red]).
		
	aCanvas drawString: 'C: ' , temperatureC asString at: 20 @ 140 font: nil color: cColor.
	
! !

!KfMithrilInspiredExperimentMorph methodsFor: 'as yet unclassified' stamp: 'pdfernhout 5/4/2023 21:08:13'!
handlesMouseDown: aMouseButtonEvent

	^ true! !

!KfMithrilInspiredExperimentMorph methodsFor: 'as yet unclassified' stamp: 'pdfernhout 5/4/2023 21:19:01'!
initialize
	super initialize.
	extent := `750@200`.
	color := Color white.
	borderColor := self defaultBorderColor.
	borderWidth := self defaultBorderWidth.! !

!KfMithrilInspiredExperimentMorph methodsFor: 'as yet unclassified' stamp: 'pdfernhout 5/4/2023 21:32:36'!
mouseButton1Down: aMouseButtonEvent localPosition: localEventPosition

	((Rectangle origin: 20 @ 60 extent: 100 @ 20) containsPoint: localEventPosition) ifTrue: [
		temperatureF := (FillInTheBlankMorph
			request: 'Enter temperature?'
			initialAnswer: temperatureF asString) asNumber.
	].

	((Rectangle origin: 20 @ 100 extent: 100 @ 20) containsPoint: localEventPosition) ifTrue: [self convert].

	self redrawNeeded.! !
