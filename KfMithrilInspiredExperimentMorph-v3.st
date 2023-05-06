'From Cuis 6.0 [latest update: #5772] on 6 May 2023 at 7:50:26 pm'!
!classDefinition: #KfMithrilInspiredExperimentMorph category: 'KfExperiments'!
BoxedMorph subclass: #KfMithrilInspiredExperimentMorph
	instanceVariableNames: 'temperatureF temperatureC subcomponents'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'KfExperiments'!
!KfMithrilInspiredExperimentMorph commentStamp: 'pdfernhout 5/4/2023 21:16:14' prior: 0!
"KfMithrilInspiredExperimentMorph new openInWorld"!


!KfMithrilInspiredExperimentMorph methodsFor: 'as yet unclassified' stamp: 'pdfernhout 5/5/2023 20:11:34'!
convert

	"This first line is kludgy as should have edit putting state into temperatureF as it changes"
	temperatureF := (self subcomponentFor: #temperatureFEdit ) text asNumber.
	
	temperatureC := self convertFToC: temperatureF.
	
	"This redrawNeeded is only needed here until the button action automatically redraws."
	self redrawNeeded.! !

!KfMithrilInspiredExperimentMorph methodsFor: 'as yet unclassified' stamp: 'pdfernhout 5/5/2023 08:00:15'!
convertFToC: f

	^  ((f - 32 ) / 9 * 5) asFloat rounded.! !

!KfMithrilInspiredExperimentMorph methodsFor: 'as yet unclassified' stamp: 'pdfernhout 5/5/2023 20:12:51'!
drawOn: aCanvas

	"KfMithrilInspiredExperimentMorph new openInWorld"

	| cColor |

	super drawOn: aCanvas.
	
	aCanvas drawString: 'Mithril-inspired Fahrenheight to Celcius Converter' at: 20 @ 20 font: nil color: Color orange.
	
	aCanvas drawString: 'F: ' at: 20 @ 60 font: nil color: Color orange.
	
	self subcomponentFor: #temperatureFEdit create: [
		| newMorph |
		newMorph := TextModelMorph withText: temperatureF asString.
		self addMorph: newMorph position: 50 @ 60.
		newMorph morphExtent: 100 @ 10.
		newMorph
	].
	
	"The PluggableButtonMorph doesn't trigger a redraw on the action yet, so that is done for now in convert." 
	self subcomponentFor: #convertButton create: [
		|newButton|
		newButton := PluggableButtonMorph new
			model: self;
			action: #convert;
			label: 'CONVERT';
			color: Color gray.
		self addMorph: newButton position: 20 @ 110.
		newButton].
	
	"aCanvas drawString: 'CONVERT' at: 20 @ 100 font: nil color: Color gray."
	
	cColor := 	((temperatureC = ((temperatureF - 32 ) / 9 * 5) asFloat rounded) 
		ifTrue: [Color green]
		ifFalse: [Color red]).
		
	aCanvas drawString: 'C: ' , temperatureC asString at: 20 @ 170 font: nil color: cColor.
	
! !

!KfMithrilInspiredExperimentMorph methodsFor: 'as yet unclassified' stamp: 'pdfernhout 5/4/2023 21:08:13'!
handlesMouseDown: aMouseButtonEvent

	^ true! !

!KfMithrilInspiredExperimentMorph methodsFor: 'as yet unclassified' stamp: 'pdfernhout 5/5/2023 20:12:03'!
initialize
	super initialize.
	
	subcomponents := Dictionary new.
	
	extent := `750@240`.
	color := Color white.
	borderColor := self defaultBorderColor.
	borderWidth := self defaultBorderWidth.
	
	temperatureF := 0! !

!KfMithrilInspiredExperimentMorph methodsFor: 'as yet unclassified' stamp: 'pdfernhout 5/5/2023 20:12:14'!
mouseButton1Down: aMouseButtonEvent localPosition: localEventPosition

	self redrawNeeded.! !

!KfMithrilInspiredExperimentMorph methodsFor: 'as yet unclassified' stamp: 'pdfernhout 5/5/2023 20:12:31'!
subcomponentFor: symbol

	^ subcomponents at: symbol! !

!KfMithrilInspiredExperimentMorph methodsFor: 'as yet unclassified' stamp: 'pdfernhout 5/5/2023 07:36:44'!
subcomponentFor: symbol create: createBlock

	^ self subcomponentFor: symbol create: createBlock configure: nil! !

!KfMithrilInspiredExperimentMorph methodsFor: 'as yet unclassified' stamp: 'pdfernhout 5/5/2023 07:36:14'!
subcomponentFor: symbol create: createBlock configure: configureBlock

	| component |
	component :=  subcomponents at: symbol ifAbsentPut: createBlock.
	configureBlock notNil ifTrue: [configureBlock value: component].

	^ component! !
