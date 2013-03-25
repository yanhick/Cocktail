#ifndef INCLUDED_cocktail_core_renderer_CheckboxRenderer
#define INCLUDED_cocktail_core_renderer_CheckboxRenderer

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

#include <cocktail/core/renderer/InputRenderer.h>
HX_DECLARE_CLASS3(cocktail,core,dom,Element)
HX_DECLARE_CLASS3(cocktail,core,dom,Node)
HX_DECLARE_CLASS3(cocktail,core,event,EventCallback)
HX_DECLARE_CLASS3(cocktail,core,event,EventTarget)
HX_DECLARE_CLASS3(cocktail,core,html,HTMLElement)
HX_DECLARE_CLASS3(cocktail,core,renderer,BlockBoxRenderer)
HX_DECLARE_CLASS3(cocktail,core,renderer,BoxRenderer)
HX_DECLARE_CLASS3(cocktail,core,renderer,CheckboxRenderer)
HX_DECLARE_CLASS3(cocktail,core,renderer,ElementRenderer)
HX_DECLARE_CLASS3(cocktail,core,renderer,FlowBoxRenderer)
HX_DECLARE_CLASS3(cocktail,core,renderer,InputRenderer)
HX_DECLARE_CLASS3(cocktail,core,renderer,InvalidatingElementRenderer)
HX_DECLARE_CLASS3(cocktail,core,utils,FastNode)
namespace cocktail{
namespace core{
namespace renderer{


class CheckboxRenderer_obj : public ::cocktail::core::renderer::InputRenderer_obj{
	public:
		typedef ::cocktail::core::renderer::InputRenderer_obj super;
		typedef CheckboxRenderer_obj OBJ_;
		CheckboxRenderer_obj();
		Void __construct(::cocktail::core::html::HTMLElement node);

	public:
		static hx::ObjectPtr< CheckboxRenderer_obj > __new(::cocktail::core::html::HTMLElement node);
		static Dynamic __CreateEmpty();
		static Dynamic __Create(hx::DynamicArray inArgs);
		~CheckboxRenderer_obj();

		HX_DO_RTTI;
		static void __boot();
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		::String __ToString() const { return HX_CSTRING("CheckboxRenderer"); }

		virtual Void createNativeInput( );

};

} // end namespace cocktail
} // end namespace core
} // end namespace renderer

#endif /* INCLUDED_cocktail_core_renderer_CheckboxRenderer */ 