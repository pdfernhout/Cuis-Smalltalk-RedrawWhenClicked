# Cuis-Smalltalk-RedrawWhenClicked
An Mithril-inspired experiment to have Cuis morphs redraw when clicked or on other events

Demo files:

KfMithrilInspiredExperimentMorph-v1.st : The first version sent to the list.

KfMithrilInspiredExperimentMorph-v2.st : Adds rough first cut at support for subcomponents with a button.

KfMithrilInspiredExperimentMorph-v3.st : Adds an edit field using a subcomponent.

KFExperiments-v4.st: Includes a new builder pattern experiment with KfFToCExperiment2Model with a buildMorph: method, supported by KfMorphBuilder and KfRebuiltWindow. Launch the demo with: "KfRebuiltWindow new openWith: KfFToCExperiment2Model new". Demo currently has an updating issue where after clicking the "Convert" button or "Show advanced" button you need to click elsewhere in the window to see the updated celsius value or the newly added input field. This filein also included the previous experiment plus an earlier unfinished experiment that uses the conventional observer/dependency pattern. KfMorphBuilder's morphToBuilderMap WeakValueDictionary is not currently used, but was intended for more general support of builders used with any morph, not just a morph installed in a KfRebuiltWindow.

KFExperiments-v5.st: Fixes updating issues in v4 (at a potential cost of more redrawing). Also adds initial layout support to builder. There is an issue with how the Panel morph gets resized when the Kelvin field is added and removed, where the show/hide  button and input field may extend beyond the boudaries of the Panel sometimes, and how the other fields may have their height adjusted. 

====

From an email I sent to the Cuis-Dev list:
https://lists.cuis.st/mailman/archives/cuis-dev/2023-May/007403.html

Hi Cuis developers. First time Cuis list poster here -- someone who is new to Cuis but old to Smalltalk and programming in general. Really liking Cuis for the focus on simplicity. But one thing seems still too complex, which is that you need to build Morphic UIs with an observer pattern using special models instead of just rerendering the UI anytime the UI is touched or otherwise "dirty". Attached is some demo code with a Proof of Concept experiment of that (arguably) simpler approach in Cuis. Below is an explanation of why that design pattern may be of interest.

--Paul Fernhout

==== More details

Let's say you are building a UI in Cuis like, say, a window where you can enter a temperature in Fahrenheit, click a button, and have the value converted to Celsius. (I know, not great UX...)

To do that now in Cuis, you would make a model (like one derived from ActiveModel) and hook up dependencies (like using when:send:to:) so that whenever the model containing those temperature values changes, then any morph who is interested in that change is notified and can update their display or sometimes their internal state.

I started writing an example like that to learn more about Cuis using two TextModelMorphs and a PluggableButtonMorph. And after getting to the point where I needed to hook up all the dependencies, I thought, I don't want to go back thirty years to the worse part of my ObjectWorks and VisualWorks days (adding endless #changed messages or similar everywhere for example, and some other observer/dependency challenges) when I have been happier in recent years developing UIs using a different design pattern.

I know there may be some performance efficiency advantages to that observer/model pattern. There may also be some UI extension benefits like being able to hook up events to other Morphs like Dan Ingalls demonstrates with Pronto or is used with VisualAge Smalltalk.

But there is a lot of complexity there too involving defining special model classes, establishing dependencies, and avoiding ringing where one dependency triggers another that re-triggers the original dependency. People may end up with complicated buildMorphicWindow methods in Cuis -- and then, when you want to add a new part to your window, you presumably usually need to close the window and open it again to rerun that definition method to hook up all the dependencies just right.

One alternative to using a model and observer dependencies is, like in many 3D graphics system, just re-rendering the entire UI frequently. How frequently? For games the rendering may be done every display refresh cycle, so like 60 times a second if possible (or more for higher refresh screens).

The advantage of rerendering frequently is that you can just draw the UI based on the latest data available. That makes the UI much easier to reason about because you only need to understand how a drawing method takes available data and draws something. You don't have to try to reason about dependencies (usually). Also, you can just modify the drawing code (which can include defining self-contained components) which on a redraw will update your entire UI (including new UI elements if needed, depending). And best of all, there are no special models needed. You just put your data anywhere in the image in no special way, and your drawing algorithm just fetches it as needed.

Of course, rerendering that many times sounds inefficient, especially on constrained mobile devices. So, to optimize rerendering, instead of brute-force high refresh rates, libraries like Mithril.js for JavaScript instead more elegantly use an approach of considering some widget on the screen as dirty and needing to be redrawn if it was listening for an event that it received. (This is sort of like having handlesMouseDown: return true for a morph in Cuis.)

So, if a widget is listening for a mouse down, and it gets one, the widget will rerender entirely after handling the mouse down. Same for keystrokes or mouse move events. Network events and timers can also potentially be hooked into this automatic redraw system, although sometimes you just need to add a redraw call yourself for special cases or to avoid modifying the base system too much. Also, you may want to override the default behavior of automatic redrawing in special cases like if you listen for keystrokes but only care about one specific one and want to avoid redrawing on others.

While that rerendering approach works OK usually in a web browser page where your data usually only affects that window, admittedly it is more problematical in a Smalltalk environment where in theory any window can draw data from anywhere. Of course, that is what the "Restore display" menu item is for in a worst case. But that issue is an admitted weakness in this idea. How serious a weakness is still in question.

Mithril is where I first learned this redrawing-when-touched design pattern, but a similar approach is also in Elm (which predates Mithril).

For those familiar with some common JavaScript libraries, what Mithril does is different than what React does. React essentially only rerenders when you call a method to modify state data in a widget. In the end that requires all sorts of complex plumbing like Redux to share state across an application and only update widgets when the special shared state changes. Essentially React in practice using Redux or similar for a complex application end up being somewhat like using an observer pattern with a special model (a Redux store).

Angular is much closer to this rerendering approach, but rather than using the elegant approach Mithril uses of hooking functions that connect up UI events so they have an automatic redraw, Angular uses more complex interventions in the heart of JavaScript with "Zones" that trigger rerenders that makes such applications harder to debug with endless extra low-level confusing layers to wade through for any UI event handler.

Attached is a simple demonstration of a Mithril-inspired rerendering idea I made today in Cuis of a "KfMithrilInspiredExperimentMorph". You can click on some areas of a BoxedMorph subclass to enter a temperature and to convert it. As the class comment shows, use "KfMithrilInspiredExperimentMorph new openInWorld" to start it.

Right now, rather than a button to do the conversion, an area of the screen occupied by some text "CONVERT" is used to trigger the conversion. Ideally there would be some way to bridge between existing Cuis morphs for buttons and text editors and this re-rendering approach (at least at first).

To get a sense of how this development process feels, try modifying the drawOn: method in some way and clicking on the morph to force a redraw. Of course, once you could include other re-rendering Morphs like a button or text area in the drawOn: method things would get more interesting, but this proof of concept is not there yet.

You could also make changes to the mouseButton1Down:localPosition: method -- where unfortunately approximate bounding boxes are currently hardcoded for areas with text. Ideally those would be defined as nested components somehow. Mithril works by using existing HMTL DOM elements, so in theory wrapping existing Cuis morphs at first should be feasible (although Mithril uses a VDOM approach to do that, which it would be best to avoid in Cuis).

Hoping to spark some ideas and more experiments including by others towards further simplifications of Cuis along these lines -- at least as an alternative at first for UI building. Someone who already knows Cuis well might be able to take this rerendering-on-touched design pattern much further much faster than I can. Then maybe if those experiments prove the concept then the core Cuis browsers and so on maybe could be rewritten this way to increase the simplicity of the core system (at least, simplicity from one perspective, even if it might use more CPU cycles sometimes perhaps, to be evaluated).

Of course, this idea might not work out in practice. It's an experiment after all. Maybe such a transformation of Cuis to this design pattern and its quantitative evaluation might even make an interesting academic thesis project for someone?

Don't know of any modern Smalltalks that use this design pattern, although would like to hear of one if such a thing existed already. Perhaps the earliest Smalltalks might have been a bit closer to this approach by using polling for events which could lead to a redraw? But that is less efficient and has other issues than being purely event-driven.

My thanks go to Juan and everyone else here for remaking Squeak in a simpler way to become Cuis -- including because it makes experiments like this one more feasible.

--Paul Fernhout (pdfernhout.net)
"The biggest challenge of the 21st century is the irony of technologies of abundance in the hands of those still thinking in terms of scarcity."

====

(Also related is this set of comments by me on "Ideas for transcending Smalltalk": https://tech.slashdot.org/comments.pl?sid=22859498&cid=63475402 )
