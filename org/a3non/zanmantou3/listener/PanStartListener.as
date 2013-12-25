package org.a3non.zanmantou3.listener{
import flash.events.*;

import org.a3non.ui.components.*;
import org.a3non.zanmantou3.*;
import org.a3non.zanmantou3.events.*;
import org.a3non.util.*;
import org.a3non.event.*;
	        
public class PanStartListener
	implements ActionListener{		
	
	private var zanmantou:Zanmantou3;

	public function PanStartListener(zanmantou:Zanmantou3){
		this.zanmantou = zanmantou;
	}

	public function actionPerformed(e:Event):void{
		this.zanmantou.getJSAPI().triggerEvent("panstart", "");
	}

}}