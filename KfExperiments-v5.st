!classDefinition: #KfFToCConverterModel category: 'KfExperiments'!
ActiveModel subclass: #KfFToCConverterModel
	instanceVariableNames: 'temperatureF temperatureC'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'KfExperiments'!

!KfFToCConverterModel methodsFor: 'accessing' stamp: 'pdfernhout 5/1/2023 09:33:54'!
temperatureC
	"Answer the value of temperatureC"

	^ temperatureC  ifNil: [0] ifNotNil: [temperatureC].! !

!KfFToCConverterModel methodsFor: 'accessing' stamp: 'pdfernhout 5/1/2023 08:30:03'!
temperatureC: anObject
	"Set the value of temperatureC"

	temperatureC := anObject! !

!KfFToCConverterModel methodsFor: 'accessing' stamp: 'pdfernhout 5/1/2023 09:34:46'!
temperatureCString
	"Answer the value of temperatureC"

	^ self temperatureC asString! !

!KfFToCConverterModel methodsFor: 'accessing' stamp: 'pdfernhout 5/1/2023 08:30:47'!
temperatureF
	"Answer the value of temperatureF"

	^ temperatureF ifNil: [0] ifNotNil: [temperatureF].! !

!KfFToCConverterModel methodsFor: 'accessing' stamp: 'pdfernhout 5/1/2023 08:30:03'!
temperatureF: anObject
	"Set the value of temperatureF"

	temperatureF := anObject! !

!KfFToCConverterModel methodsFor: 'accessing' stamp: 'pdfernhout 5/1/2023 09:34:23'!
temperatureFString
	"Answer the value of temperatureF"

	^ self temperatureF asString! !


!classDefinition: #KfFToCConverterWindow category: 'KfExperiments'!
SystemWindow subclass: #KfFToCConverterWindow
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'KfExperiments'!

!KfFToCConverterWindow methodsFor: 'as yet unclassified' stamp: 'pdfernhout 5/1/2023 09:35:08'!
buildMorphicWindow

	"KfFToCConverterWindow open: KfFToCConverterModel new label: 'F to C Converter' "

	| row convertButton column temperatureCText temperatureFText |
	column := LayoutMorph newColumn.
	
	row := LayoutMorph newRow.
	
	temperatureFText := TextModelMorph textProvider: model textGetter: #temperatureFString.
	
	convertButton := PluggableButtonMorph model: self action: #convert label: 'Convert F to C'.
	"convertButton  icon: Theme current goUpIcon."
	
	temperatureCText := TextModelMorph textProvider: model textGetter: #temperatureCString.
	
	row addMorph: temperatureFText.
	row addMorph: convertButton.
	row addMorph: temperatureCText.
	
	column addMorph: row.
	
	layoutMorph addMorph: column.
		! !

!KfFToCConverterWindow methodsFor: 'as yet unclassified' stamp: 'pdfernhout 5/4/2023 20:24:50'!
convert

	| temperatureC |
	temperatureC :=  ((model temperatureF - 32 ) / 9 * 5) asFloat rounded.
	
	Transcript show: 'temperatureC '; show: temperatureC; cr.
	
	self model temperatureC: temperatureC.
	
	self redrawNeeded.! !


!classDefinition: #KfRebuiltWindow category: 'KfExperiments'!
SystemWindow subclass: #KfRebuiltWindow
	instanceVariableNames: 'builder'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'KfExperiments'!

!KfRebuiltWindow methodsFor: 'as yet unclassified' stamp: 'pdfernhout 5/14/2023 10:16:20'!
buildMorph

	self layoutMorph removeAllMorphs.
	self model buildMorph: builder.
	"Doesn't seem to have an effect: builder morph layoutMorph refreshExtent."
	self layoutMorph addMorph: builder morph.
	! !

!KfRebuiltWindow methodsFor: 'as yet unclassified' stamp: 'pdfernhout 5/14/2023 09:19:13'!
dispatchEvent: aMorphicEvent

	| result |
	result := super dispatchEvent: aMorphicEvent.
	(result = #rejected) ifFalse: [self model buildMorph: builder].
	^ result! !

!KfRebuiltWindow methodsFor: 'as yet unclassified' stamp: 'pdfernhout 5/13/2023 19:37:07'!
initialize

	super initialize.
	self setLabel: 'KfRebuiltWindow experiment'.
	builder := KfMorphBuilder new.
	! !

!KfRebuiltWindow methodsFor: 'as yet unclassified' stamp: 'pdfernhout 5/13/2023 12:34:14'!
openWith: aModel

	self model: aModel.
	self buildMorph.
	self openInWorld.! !


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


!classDefinition: #KfFToCExperiment2Model category: 'KfExperiments'!
Object subclass: #KfFToCExperiment2Model
	instanceVariableNames: 'temperatureF temperatureC showAdvanced'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'KfExperiments'!

!KfFToCExperiment2Model methodsFor: 'as yet unclassified' stamp: 'pdfernhout 5/14/2023 09:04:46'!
buildMorph: builder

        "KfRebuiltWindow new openWith: KfFToCExperiment2Model new"

	| showAdvancedLabel |
	
	Transcript show: 'buildMorph ' ,  temperatureF asString , ' ', temperatureC asString; cr.
	
	builder create: [Panel new model: self; setLabel: 'F to C'].
	
	builder namedSubmorph: #eFLabel create: [LabelMorph contents: 'Fahrenheit'].
	
	builder 
		namedSubmorph: #eF
		create: [ | newMorph |
			newMorph := SimpleNumberEntryMorph integerDefault: temperatureF maxNumChars: 9.
			newMorph crAction: [
				Transcript show: 'crAction', newMorph contents.
				temperatureF := newMorph contents asNumber].
			newMorph layoutSpec: (LayoutSpec fixedWidth: 100).
			"newMorph morphExtent: 140@30."
			newMorph]
		update: [:submorph | 
			Transcript show: 'set value F ' , temperatureF asString; cr. 
			submorph setValue: temperatureF.]
		layout: 'wrap'.
		
	builder namedSubmorph: #b create: [
		PluggableButtonMorph
			model: [self convertFToC]
		    	stateGetter: nil
		    	action: #value
		    	label: 'Convert F to C'
		].
	
	builder namedSubmorph: #eCLabel create: [LabelMorph contents: 'Celsius' ] layout: 'newline'.
	
	builder 
		namedSubmorph: #eC 
		create: [SimpleNumberEntryMorph integerDefault: temperatureC maxNumChars: 9] 
		update: [:submorph | Transcript show: 'update'; cr. submorph setValue: temperatureC].
		
	showAdvancedLabel := showAdvanced ifTrue: ['Hide advanced'] ifFalse: ['Show advanced'].
	builder 
		namedSubmorph: #advancedToggle 
		create: [
			PluggableButtonMorph
				model: [showAdvanced := showAdvanced ifNil: [true] ifNotNil: [showAdvanced not]]
			    	stateGetter: nil
			    	action: #value
			    	label: showAdvancedLabel
			]
		update: [:submorph | submorph label: showAdvancedLabel].

	showAdvanced ifTrue: [ 
		| k |
		k := (temperatureC + 273.15) asFloat rounded.
		builder namedSubmorph: #eKLabel create: [LabelMorph contents: 'Kelvin' ] layout: 'newline'.
		builder 
			namedSubmorph:	 #eK 
			create: [SimpleNumberEntryMorph integerDefault: k maxNumChars: 9]
			update: [:submorph | submorph setValue: k].
		].
	
	"builder morph morphExtent: 200@160.
	(builder namedSubmorph: #b) morphExtent: 140@30."
	
	^builder morph
! !

!KfFToCExperiment2Model methodsFor: 'as yet unclassified' stamp: 'pdfernhout 5/13/2023 13:28:30'!
convertFToC

	temperatureC :=  ((temperatureF - 32 ) / 9 * 5) asFloat rounded.
	
	Transcript show: 'temperatureC '; show: temperatureC; cr.
	! !

!KfFToCExperiment2Model methodsFor: 'as yet unclassified' stamp: 'pdfernhout 5/13/2023 09:20:43'!
initialize

        temperatureF := 32.
	temperatureC := 0.
	showAdvanced := false.! !


!classDefinition: #KfMorphBuilder category: 'KfExperiments'!
Object subclass: #KfMorphBuilder
	instanceVariableNames: 'model morph namedSubmorphs layoutColumnsInRow layoutColumnsSpecified layoutRow'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'KfExperiments'!

!KfMorphBuilder methodsFor: 'as yet unclassified' stamp: 'pdfernhout 5/13/2023 08:50:27'!
create: createBlock

	^ self create: createBlock update: nil! !

!KfMorphBuilder methodsFor: 'as yet unclassified' stamp: 'pdfernhout 5/14/2023 09:37:41'!
create: createBlock update: updateBlock

	morph 
		ifNil: [morph := createBlock value.
			self class builderForMorph: morph put: self] 
		ifNotNil: [morph layoutMorph removeAllMorphs].
	updateBlock notNil ifTrue: [updateBlock value: morph].
	layoutRow := nil.
	layoutColumnsInRow := 0.
	layoutColumnsSpecified := nil.

	^ morph! !

!KfMorphBuilder methodsFor: 'as yet unclassified' stamp: 'pdfernhout 5/13/2023 20:01:06'!
initialize

	namedSubmorphs := Dictionary new.
	layoutColumnsInRow := 0.
	layoutColumnsSpecified := nil.
	! !

!KfMorphBuilder methodsFor: 'as yet unclassified' stamp: 'pdfernhout 5/13/2023 09:05:09'!
morph

	^ morph! !

!KfMorphBuilder methodsFor: 'as yet unclassified' stamp: 'pdfernhout 5/13/2023 08:44:49'!
namedSubmorph: symbol

	^ namedSubmorphs at: symbol! !

!KfMorphBuilder methodsFor: 'as yet unclassified' stamp: 'pdfernhout 5/13/2023 19:53:31'!
namedSubmorph: symbol create: createBlock

	^ self namedSubmorph: symbol create: createBlock update: nil layout: nil
! !

!KfMorphBuilder methodsFor: 'as yet unclassified' stamp: 'pdfernhout 5/13/2023 19:52:59'!
namedSubmorph: symbol create: createBlock layout: layout

	^ self namedSubmorph: symbol create: createBlock update: nil layout: layout
! !

!KfMorphBuilder methodsFor: 'as yet unclassified' stamp: 'pdfernhout 5/13/2023 19:54:10'!
namedSubmorph: symbol create: createBlock update: updateBlock

	^ self namedSubmorph: symbol create: createBlock update: updateBlock layout: nil
! !

!KfMorphBuilder methodsFor: 'as yet unclassified' stamp: 'pdfernhout 5/14/2023 09:41:02'!
namedSubmorph: symbol create: createBlock update: updateBlock layout: layout

	| component |
	component :=  namedSubmorphs at: symbol ifAbsentPut: createBlock.
	updateBlock notNil ifTrue: [updateBlock value: component].
	
	"Not used as decided to set layoutSpec directly on morphs:
	(layout class == LayoutSpec) ifTrue: [layoutSpec := layout. layout := nil].
	layout isArray ifTrue: [layoutSpec := layout at: 2. layout := layout at: 1]."
	
	"Layout approach is inspired by MiG Layout"
	(layout = 'wrap') ifTrue: [layoutColumnsSpecified := layoutColumnsInRow + 1].
	(layoutColumnsInRow = layoutColumnsSpecified or: [layout = 'newline']) 
		ifTrue: [layoutRow := nil. layoutColumnsInRow := 0].
	(layoutRow = nil) ifTrue: [
		layoutRow := LayoutMorph newRow color: Color transparent.
		morph layoutMorph addMorph: layoutRow.
		layoutColumnsInRow := 0].
	layoutRow addMorph: component.
	layoutColumnsInRow := layoutColumnsInRow + 1.	

	^ component! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'KfMorphBuilder class' category: 'KfExperiments'!
KfMorphBuilder class
	instanceVariableNames: 'morphToBuilderMap'!

!KfMorphBuilder class methodsFor: 'as yet unclassified' stamp: 'pdfernhout 5/13/2023 11:15:12'!
builderForMorph: morph

	^ morphToBuilderMap at: morph! !

!KfMorphBuilder class methodsFor: 'as yet unclassified' stamp: 'pdfernhout 5/13/2023 11:14:25'!
builderForMorph: morph put: builder

	morphToBuilderMap at: morph put: builder.! !

!KfMorphBuilder class methodsFor: 'as yet unclassified' stamp: 'pdfernhout 5/13/2023 11:11:50'!
initialize

	"KfMorphBuilder initialize"
	
	morphToBuilderMap := WeakValueDictionary new! !

KfMorphBuilder initialize!