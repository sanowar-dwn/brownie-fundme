from brownie import Fundme
from scripts.helpful_scripts import get_account

def deploy_fund_me():
    account = get_account()
    fund_me = Fundme.deploy({"from":account}, publish_source=True)
    print(f"contract deploted to {fund_me.address}")


def main():
    deploy_fund_me()