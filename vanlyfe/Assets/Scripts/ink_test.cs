using Ink.Runtime;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;


public class ink_test : MonoBehaviour
{
    public TextAsset inkJSON;
    private Story story;
    public TMPro.TMP_Text textPrefab;
    public Button buttonPrefab;
    public GameObject onClickContinue;


    // Start is called before the first frame update
    void Start()
    {
        story = new Story (inkJSON.text);
        refreshUI();

    }

    void chooseStoryChoice(Choice choice)
    {

        story.ChooseChoiceIndex(choice.index);
        refreshUI();

    }

    void eraseUI()
    {
        for(int i=0; i < this.transform.childCount; i++)
        {
            Destroy(this.transform.GetChild(i).gameObject);
        }
    }

    void refreshUI()
    {
        eraseUI();

        TMPro.TMP_Text storyText = Instantiate(textPrefab) as TMPro.TMP_Text;
        
        string text = loadStoryChunk();

        
        List<string> tags = story.currentTags;

        if(tags.Count > 0)
        {
        text = tags[0] + " : " + text;
        }

        storyText.text = text;
        storyText.transform.SetParent(this.transform, false);


        foreach (Choice choice in story.currentChoices)
        {
            Button choiceButton = Instantiate(buttonPrefab) as Button;
            choiceButton.transform.SetParent(this.transform, false);
            
            TMPro.TMP_Text choiceText = choiceButton.GetComponentInChildren<TMPro.TMP_Text>();
            choiceText.text = choice.text;

            choiceButton.onClick.AddListener(delegate {
                chooseStoryChoice(choice);
            });
        }
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void clickContinue()
    {
                refreshUI();

    }

    string loadStoryChunk()
    {
        string text = "";

        if(story.canContinue)
        {
        text = story.Continue();
      
        }

        return text;
    }
}
