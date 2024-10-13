#include <framework/core.h>
#include <framework/logging.h>
#include <framework/ui.h>
#include <framework/gui.h>
#include <framework/async.h>
#include <framework/event.h>
#include <framework/message.h>
#include <framework/system.h>
#include <framework/worldcell.h>
#include <framework/language.h>
#include <framework/file.h>
#include <framework/path.h>
#include <framework/stats.h>
#include <framework/script.h>
#include <framework/settings.h>
#include <components/trigger.h>
#include <audio/audio.h>
#include <audio/sound.h>
#include <render/render.h>
#include <render/material.h>
#include <render/api.h>
#include <render/aabb.h>
#include <physics/physics.h>
#include <physics/api.h>
#include <entities/player.h>
#include <entities/staticworldobject.h>
#include <entities/light.h>
#include <entities/crate.h>
#include <entities/marker.h>
#include <entities/trigger.h>
#include <entities/sound.h>
#include <entities/decoration.h>
#include <components/player.h>
#include <components/animation.h>
#include <components/controller.h>
#include <components/render.h>
#include <extensions/camera/camera.h>
#include <extensions/menu/menu.h>
#include <extensions/scripting/lua.h>
#include <extensions/kitchensink/design.h>
#include <extensions/kitchensink/entities.h>
#include <extensions/kitchensink/soundtable.h>

using namespace tram;
using namespace tram::UI;
using namespace tram::Render;
using namespace tram::Physics;
using namespace tram::Ext::Design;

void main_loop();

int main(int argc, const char** argv) {
	SetSystemLoggingSeverity(System::SYSTEM_PLATFORM, SEVERITY_WARNING);
	
	Settings::Parse(argv, argc);
	
	Light::Register();
    Crate::Register();
    Sound::Register();
    Decoration::Register();
    Trigger::Register();
    StaticWorldObject::Register();
    Ext::Design::Button::Register();
	
	Core::Init();
	UI::Init();
	Render::Init();
	Physics::Init();
#ifdef __EMSCRIPTEN__
	Async::Init(0);
#else
	Async::Init();
#endif
	Audio::Init();
	GUI::Init();

	Ext::Menu::Init();
	Ext::Camera::Init();
	Ext::Design::Init();

	Ext::Scripting::Lua::Init();
	Script::Init();

	Material::LoadMaterialInfo("material");
	Language::Load("en");
	
	Script::LoadScript("init");
	
	#ifdef __EMSCRIPTEN__
		UI::SetWebMainLoop(main_loop);
	#else
		while (!UI::ShouldExit()) {
			main_loop();
		}

		Ext::Scripting::Lua::Uninit();
		
		Async::Yeet();
		Audio::Uninit();
		UI::Uninit();
	#endif
}

void main_loop() {
	Core::Update();
	UI::Update();
	Physics::Update();	

	GUI::Begin();
	Ext::Menu::Update();

	Event::Dispatch();
	Message::Dispatch();
	
	GUI::End();
	GUI::Update();
	
#ifdef __EMSCRIPTEN__
	Async::LoadResourcesFromDisk();
#endif
	Async::LoadResourcesFromMemory();
	Async::FinishResources();
	
	Loader::Update();
	
	AnimationComponent::Update();
	
	Render::Render();
	UI::EndFrame();
	
	Stats::Collate();
}