package testimpl

import (
	"context"
	"os"
	"strings"
	"testing"

	"github.com/Azure/azure-sdk-for-go/sdk/azidentity"
	"github.com/Azure/azure-sdk-for-go/sdk/resourcemanager/network/armnetwork"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/launchbynttdata/lcaf-component-terratest/types"
	"github.com/stretchr/testify/assert"
)

func TestWafPolicyComplete(t *testing.T, ctx types.TestContext) {
	subscriptionId := os.Getenv("ARM_SUBSCRIPTION_ID")
	if len(subscriptionId) == 0 {
		t.Fatal("ARM_SUBSCRIPTION_ID environment variable is not set")
	}

	cred, err := azidentity.NewDefaultAzureCredential(nil)
	if err != nil {
		t.Fatalf("Unable to get credentials: %v\n", err)
	}

	t.Run("TestWafPolicyID", func(t *testing.T) {
		checkWafPolicyID(t, ctx, subscriptionId, cred)
	})
}

func checkWafPolicyID(t *testing.T, ctx types.TestContext, subscriptionId string, cred *azidentity.DefaultAzureCredential) {
	resourceGroupName := terraform.Output(t, ctx.TerratestTerraformOptions(), "resource_group_name")
	wafPolicyID := terraform.Output(t, ctx.TerratestTerraformOptions(), "waf_policy_id")
	wafPolicyName := terraform.Output(t, ctx.TerratestTerraformOptions(), "waf_policy_name")

	client := NewWafPoliciesClient(t, subscriptionId, cred)

	wafPolicy, err := client.Get(context.TODO(), resourceGroupName, wafPolicyName, nil)
	assert.NoError(t, err, "Failed to retrieve WAF Policy from Azure")

	assert.True(
		t,
		// case insensitive comparison
		strings.EqualFold(wafPolicyID, *wafPolicy.ID),
		"WAF Policy ID doesn't match",
	)
}

func NewWafPoliciesClient(t *testing.T, subscriptionId string, cred *azidentity.DefaultAzureCredential) *armnetwork.WebApplicationFirewallPoliciesClient {
	client, err := armnetwork.NewWebApplicationFirewallPoliciesClient(subscriptionId, cred, nil)
	if err != nil {
		t.Fatalf("Error creating WAF Policy client: %v", err)
	}
	return client
}
