pragma solidity ^0.4.16;

contract AdministratableContract {
  address super_admin;
  mapping (address=>bool) admins;

  function AdministratableContract() {
    super_admin = msg.sender;
    admins[msg.sender] = true;
  }
  
  modifier is_admin {
    require(admins[msg.sender]);
    _;
  }

  function add_admin(address new_admin)
    external
    is_admin {
    require(admins[new_admin] == false);	
    admins[new_admin] = true;
  }

  function remove_admin(address old_admin)
    external
    is_admin {
    require(old_admin != super_admin);
    require(admins[old_admin] == true);	
    admins[old_admin] = false;
  }

  function change_super_admin(address new_super_admin)
    external
    is_admin {
    super_admin = new_super_admin;
  }
}

contract BenefactorPayingContract is AdministratableContract {
  address benefactor;
  uint balance_released_to_benefactor;
  
  modifier is_benefactor {
    require(msg.sender == benefactor);
    _;
  }

  function BenefactorPayingContract() {
    benefactor = msg.sender;
    balance_released_to_benefactor = 0;    
  }

  function change_benefactor(address new_benefactor)
  external
  is_admin {
    require(new_benefactor != benefactor);
    benefactor = new_benefactor;
  }

  function collect_benefits()
    external
    is_benefactor {
    // change state before transfer, avoid infinite withdrawal
    uint amount_to_send = balance_released_to_benefactor;
    balance_released_to_benefactor = 0;
    benefactor.transfer(amount_to_send);
  }
}
