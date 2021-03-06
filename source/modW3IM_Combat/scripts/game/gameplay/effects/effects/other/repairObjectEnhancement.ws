/***********************************************************************/
/** 	© 2015 CD PROJEKT S.A. All rights reserved.
/** 	THE WITCHER® is a trademark of CD PROJEKT S. A.
/** 	The Witcher game is based on the prose of Andrzej Sapkowski.
/***********************************************************************/


//modW3IM_Combat ++
class W3RepairObjectEnhancement extends CBaseGameplayEffect
{
	private saved var currCharge : float;
	private saved var initCharge : float;

	default isPositive = true;

	// this needs to be an empty function to prevent script conficts
	public function OnTimeUpdated(dt : float){}

	event OnEffectAdded(customParams : W3BuffCustomParams)
	{
		var enhancementParams : W3EnhancementBuffParams;

		enhancementParams = (W3EnhancementBuffParams)customParams;
		if (enhancementParams)
		{
			currCharge = enhancementParams.currCharge;
			initCharge = enhancementParams.initCharge;
		}

		super.OnEffectAdded(customParams);
	}

	public final function GetCurrentCharge() : float
	{
		return currCharge;
	}

	public final function GetInitialCharge() : float
	{
		return initCharge;
	}

	public final function Reapply(count : float) : void
	{
		currCharge = count;
		initCharge = count;
	}

	public final function ReduceCharge(amount: float) : void
	{
		currCharge -= amount;
		if (currCharge <= 0)
		{
			GetWitcherPlayer().RemoveBuff(this.effectType);
		}
	}
}

class W3EnhancementBuffParams extends W3BuffCustomParams
{
	var currCharge : float;
	var initCharge : float;
}
//modW3IM_Combat --