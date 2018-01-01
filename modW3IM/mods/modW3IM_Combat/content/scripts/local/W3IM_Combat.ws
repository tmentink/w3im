
function W3IM_Combat_ApplyEnhancement(armor : bool, weapon : bool) : bool
{
	var arrEnhancements : array<CBaseGameplayEffect>;
	var buffParams : SCustomEffectParams;
	var count : float;
	var enhancementParams : W3EnhancementBuffParams;
	var existingEnhancement : W3RepairObjectEnhancement;
	var optionName : CName;

	enhancementParams = new W3EnhancementBuffParams in thePlayer;

	if(armor)
	{
		buffParams.effectType = EET_EnhancedArmor;
		optionName = 'iWorkbenchCharges';
	}
	else if (weapon)
	{
		buffParams.effectType = EET_EnhancedWeapon;
		optionName = 'iGrindstoneCharges';
	}
	else
	{
		return false;
	}

	arrEnhancements = GetWitcherPlayer().GetBuffs(buffParams.effectType);
	count = StringToFloat(theGame.GetInGameConfigWrapper().GetVarValue('W3IM_Combat', optionName));	
	existingEnhancement = (W3RepairObjectEnhancement)arrEnhancements[0];

	if(existingEnhancement)
	{
		existingEnhancement.Reapply(count);
	}
	else
	{
		buffParams.creator = thePlayer;
		enhancementParams.initCharge = count;
		enhancementParams.currCharge = count;
		buffParams.buffSpecificParams = enhancementParams;

		thePlayer.AddEffectCustom(buffParams);

		delete enhancementParams;
	}

	return true;
}

function W3IM_Combat_GetAmountMultiplier(multOption : CName) : float
{
	var amountMult : float;
	amountMult = 1.0f;
	
	if (multOption != '')
	{
		amountMult = StringToFloat(theGame.GetInGameConfigWrapper().GetVarValue('W3IM_Combat', multOption));
	}

	return amountMult;
}

function W3IM_Combat_ProcessReduceEnhancement(action : W3DamageAction, attackAction : W3Action_Attack, actorAttacker : CActor, actorVictim : CActor, playerAttacker : CR4Player, playerVictim : CR4Player, weaponId : SItemUniqueId) : void
{
	if (attackAction && playerVictim)
	{
		if (attackAction.IsCountered())
		{
			//theGame.GetGuiManager().ShowNotification('Player countered');
			W3IM_Combat_ReduceEnhancementCharge(EET_EnhancedWeapon, 'fReduceCharges_CounteredMult');
		}
		else if (attackAction.IsParried())
		{
			//theGame.GetGuiManager().ShowNotification('Player parried');
			W3IM_Combat_ReduceEnhancementCharge(EET_EnhancedWeapon, 'fReduceCharges_ParriedMult');
		}
		else if (action.DealsAnyDamage() && !attackAction.IsDoTDamage())
		{
			if (action.IsCriticalHit())
			{
				//theGame.GetGuiManager().ShowNotification('Player was critically hit');
				W3IM_Combat_ReduceEnhancementCharge(EET_EnhancedArmor, 'fReduceCharges_CriticalHitMult');
			}
			else if (actorAttacker.IsHeavyAttack(attackAction.GetAttackName()) ||
		    		 actorAttacker.IsSuperHeavyAttack(attackAction.GetAttackName()))
			{
				//theGame.GetGuiManager().ShowNotification('Player was heavily hit');
				W3IM_Combat_ReduceEnhancementCharge(EET_EnhancedArmor, 'fReduceCharges_HeavyAttackMult');
			}
			else
			{
				//theGame.GetGuiManager().ShowNotification('Player was lightly hit');
				W3IM_Combat_ReduceEnhancementCharge(EET_EnhancedArmor, '');
			}
		}
	}
	else if (attackAction && playerAttacker && actorVictim && action.IsActionMelee())
	{
		if (attackAction.IsCountered())
		{
			//theGame.GetGuiManager().ShowNotification('NPC countered');
			W3IM_Combat_ReduceEnhancementCharge(EET_EnhancedWeapon, 'fReduceCharges_CounteredMult');
		}
		else if (attackAction.IsParried())
		{
			//theGame.GetGuiManager().ShowNotification('NPC parried');
			W3IM_Combat_ReduceEnhancementCharge(EET_EnhancedWeapon, 'fReduceCharges_ParriedMult');
		}
		else if (action.DealsAnyDamage() && !playerAttacker.inv.IsItemFists(weaponId))
		{
			//theGame.GetGuiManager().ShowNotification('NPC was hit');
			W3IM_Combat_ReduceEnhancementCharge(EET_EnhancedWeapon, '');
		}
	}
}

function W3IM_Combat_ReduceEnhancementCharge(effectType : EEffectType, multOption : CName) : void
{
	var amountMult : float;
	var arrEnhancements : array<CBaseGameplayEffect>;
	var enhancement : W3RepairObjectEnhancement;
	
	amountMult = W3IM_Combat_GetAmountMultiplier(multOption);	
	arrEnhancements = GetWitcherPlayer().GetBuffs(effectType);
	enhancement = (W3RepairObjectEnhancement)arrEnhancements[0];
	enhancement.ReduceCharge(1.0f * amountMult);
}
