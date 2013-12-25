package org.a3non.zanmantou3{

import org.a3non.zanmantou3.*;
import org.a3non.ui.components.*;
import org.a3non.zanmantou3.engines.*;
import org.a3non.ui.*;

public class ComponentManager extends ContainerComponent{
	

	
	private var zanmantou:Zanmantou3;
	
	private var engineComponent:ContainerComponent;

	private var nengineComponent:RAWComponent;
	private var fengineComponent:RAWComponent;

	private var nComponent:ContainerComponent;
	private var fComponent:ContainerComponent;

	private var fullscreenActive:Boolean = false;

	// loading component container
	private var loadingComponentContainer:RAWComponent;

	public function ComponentManager(zanmantou:Zanmantou3){
		this.zanmantou = zanmantou;
		
		// create new loading component container
		this.loadingComponentContainer = new RAWComponent();
		
		this.engineComponent = new ContainerComponent("engine");
		this.nComponent = new ContainerComponent();
		this.fComponent = new ContainerComponent();

		// add components to root
		this.addComponent(this.nComponent);
		this.addComponent(this.fComponent);	
		this.addComponent(this.loadingComponentContainer);
		
		this.nengineComponent = new RAWComponent("nengine");
		this.nComponent.addComponent(this.nengineComponent);
		
		this.nengineComponent.addComponent(this.engineComponent);
		
		this.fengineComponent = new RAWComponent("fengine");
		this.fComponent.addComponent(this.fengineComponent);
		this.fComponent.visible = false;	
		this.nComponent.visible = false;
	}
	
	public function enableFullscreen(e:Boolean):void{
		this.fullscreenActive = e;
		
		if (e){
			this.nengineComponent.removeComponent(this.engineComponent);
			this.fengineComponent.addComponent(this.engineComponent);			

			this.zanmantou.enableFullscreen(true);
			
			this.fComponent.visible = true;
			this.nComponent.visible = false;			
			
			
		}else{
			this.fengineComponent.removeComponent(this.engineComponent);
			this.nengineComponent.addComponent(this.engineComponent);

			this.zanmantou.enableFullscreen(false);

			this.nComponent.visible = true;
			this.fComponent.visible = false;
			
		}
	}
	public function isFullscreenActive():Boolean{
		return this.fullscreenActive;
	}
	
	public function getEngineComponent():ContainerComponent{
		return this.engineComponent;
	}
	public function getNormalEngineComponent():RAWComponent{
		return this.nengineComponent;
	}
	public function getFullscreenEngineComponent():RAWComponent{
		return this.fengineComponent;
	}
	public function getNormalComponent():ContainerComponent{
		return this.nComponent;
	}
	public function getLoadingComponent():RAWComponent{
		return this.loadingComponentContainer;
	}
	public function getFullscreenComponent():ContainerComponent{
		return this.fComponent;
	}
}}