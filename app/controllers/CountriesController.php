<?php
use Phalcon\Mvc\Model\Criteria;
use Phalcon\Paginator\Adapter\Model as Paginator;
use Phalcon\Validation;
use Phalcon\Validation\Validator\StringLength;

class CountriesController extends ControllerBase
{
    /**
     * Index action
     */
    public function indexAction()
    {
        $this->persistent->parameters = null;

        // show the current list
        $numberPage = 1;
        $parameters["order"] = "country_id";
        $countries = Countries::find($parameters);

        $paginator = new Paginator(array(
            'data' => $countries,
            'limit'=> 10,
            'page' => $numberPage
        ));

        $this->view->page = $paginator->getPaginate();
    }

    /**
     * Searches for countries
     */
    public function searchAction()
    {
        $numberPage = 1;
        if ($this->request->isPost()) {
            $query = Criteria::fromInput($this->di, 'Countries', $_POST);
            $this->persistent->parameters = $query->getParams();
        } else {
            $numberPage = $this->request->getQuery("page", "int");
        }

        $parameters = $this->persistent->parameters;
        if (!is_array($parameters)) {
            $parameters = array();
        }
        $parameters["order"] = "country_id";

        $countries = Countries::find($parameters);
        if (count($countries) == 0) {
            $this->flash->notice("The search did not find any countries");

            $this->dispatcher->forward(array(
                "controller" => "countries",
                "action" => "index"
            ));

            return;
        }

        $paginator = new Paginator(array(
            'data' => $countries,
            'limit'=> 10,
            'page' => $numberPage
        ));

        $this->view->page = $paginator->getPaginate();
    }

    /**
     * Displays the creation form
     */
    public function newAction()
    {
        $validation = new Validation();
        $validation
            ->add('country_currency', new StringLength(array(
                'messageMinimum'    => 'Currency must be 3 digits following ISO 4217 Currency Codes',
                'min'               => 3,
                'cancelOnFail'      => true
            )));
    }

    /**
     * Edits a countrie
     *
     * @param string $country_id
     */
    public function editAction($country_id)
    {
        if (!$this->request->isPost()) {

            $countrie = Countries::findFirstBycountry_id($country_id);
            if (!$countrie) {
                $this->flash->error("Country not found");

                $this->dispatcher->forward(array(
                    'controller' => "countries",
                    'action' => 'index'
                ));

                return;
            }

            $this->view->country_id = $countrie->country_id;

            $this->tag->setDefault("country_id", $countrie->country_id);
            $this->tag->setDefault("country_name", $countrie->country_name);
            $this->tag->setDefault("country_currency", $countrie->country_currency);
            $this->tag->setDefault("country_trade", $countrie->country_trade);
            $this->tag->setDefault("markup_value", $countrie->markup_value);
        }
    }

    /**
     * Creates a new countrie
     */
    public function createAction()
    {
        if (!$this->request->isPost()) {
            $this->dispatcher->forward(array(
                'controller' => "countries",
                'action' => 'index'
            ));

            return;
        }

        $validation = new Validation();
        $validation 
            ->add('country_currency', new StringLength(array(
                'messageMinimum'    => 'Currency must be 3 digits following ISO 4217 Currency Codes',
                'min'               => 3,
                'cancelOnFail'      => true
            )));

        $countrie = new Countries();
        $countrie->country_name = $this->request->getPost("country_name");
        $countrie->country_currency = $this->request->getPost("country_currency");
        $countrie->country_trade = $this->request->getPost("country_trade");
        $countrie->markup_value = $this->request->getPost("markup_value");

        $duplicate_cname = Countries::findFirst("country_name = '$countrie->country_name'");
        $duplicate_code = Countries::findFirst("country_currency = '$countrie->country_currency'");

        if(!$duplicate_cname && !$duplicate_code) {

            if (!$countrie->save()) {
                foreach ($countrie->getMessages() as $message) {
                    $this->flash->error($message);
                }

                $this->dispatcher->forward(array(
                    'controller' => "countries",
                    'action' => 'new'
                ));

                return;
            }

            $this->flash->success("Country was created successfully");

            $this->view->disable();
            return $this->response->redirect("countries/index");

        } else {

            $this->flash->error("Duplicate Record found. Please update your information.");

            $this->dispatcher->forward(array(
                'controller' => "countries",
                'action' => 'new'
            ));

        }
    }

    /**
     * Saves a countrie edited
     *
     */
    public function saveAction()
    {

        if (!$this->request->isPost()) {
            $this->dispatcher->forward(array(
                'controller' => "countries",
                'action' => 'index'
            ));

            return;
        }

        $country_id = $this->request->getPost("country_id");
        $countrie = Countries::findFirstBycountry_id($country_id);

        if (!$countrie) {
            $this->flash->error("countrie does not exist " . $country_id);

            $this->dispatcher->forward(array(
                'controller' => "countries",
                'action' => 'index'
            ));

            return;
        }

        $countrie->country_name = $this->request->getPost("country_name");
        $countrie->country_currency = $this->request->getPost("country_currency");
        $countrie->country_trade = $this->request->getPost("country_trade");
        $countrie->markup_value = $this->request->getPost("markup_value");

        if (!$countrie->save()) {

            foreach ($countrie->getMessages() as $message) {
                $this->flash->error($message);
            }

            $this->dispatcher->forward(array(
                'controller' => "countries",
                'action' => 'edit',
                'params' => array($countrie->country_id)
            ));

            return;
        }

        $this->flash->success("Country was updated successfully");

        $this->view->disable();
        return $this->response->redirect("countries/index");
    }

    /**
     * Deletes a countrie
     *
     * @param string $country_id
     */
    public function deleteAction($country_id)
    {
        $countrie = Countries::findFirstBycountry_id($country_id);
        if (!$countrie) {
            $this->flash->error("Country not found");

            $this->dispatcher->forward(array(
                'controller' => "countries",
                'action' => 'index'
            ));

            return;
        }

        if (!$countrie->delete()) {

            foreach ($countrie->getMessages() as $message) {
                $this->flash->error($message);
            }

            $this->dispatcher->forward(array(
                'controller' => "countries",
                'action' => 'search'
            ));

            return;
        }

        $this->flash->success("Country was deleted successfully");

        $this->view->disable();
        return $this->response->redirect("countries/index");
    }

}
